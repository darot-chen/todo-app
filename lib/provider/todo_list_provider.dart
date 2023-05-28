import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_challenge/model/todo_list_model.dart';
import 'package:todo_app_challenge/model/user_todo_list_model.dart';
import 'package:todo_app_challenge/service/firebase_service.dart';
import 'package:todo_app_challenge/service/storage_service.dart';

class TodoListProvider extends ChangeNotifier {
  List<TodoListModel> todoList = [];
  List<TodoListModel> searchTodoList = [];
  List<TodoListModel> completedTodoList = [];
  List<TodoListModel> searchCompletedTodoList = [];

  int totalTodo = 0;

  bool _isOnline = false;
  bool get isOnline => _isOnline;
  set isOnline(bool status) {
    _isOnline = status;
    if (!status) load();
    notifyListeners();
  }

  bool _isOwner = false;
  bool get isOwner => _isOwner;
  set isOwner(bool status) {
    _isOwner = status;
  }

  String _userCode = '';
  String get userCode => _userCode;
  set userCode(String username) {
    _userCode = username;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  bool _isEdit = false;
  bool get isEdit => _isEdit;
  set isEdit(bool edit) {
    _isEdit = edit;
    notifyListeners();
  }

  Future<void> shareOnline() async {
    final String? deviceId = await PlatformDeviceId.getDeviceId;
    if (deviceId == null) return;
    userCode = deviceId;

    isOnline = true;
    isOwner = true;

    _writeToStorage();
    notifyListeners();
  }

  Future<void> stopShareOnline() async {
    isOnline = false;
    isOwner = false;
    await _writeToStorage();
    await load();
  }

  Future<void> streamData(UserTodoListModel? userTodo) async {
    if (userTodo != null) {
      todoList = userTodo.todoList ?? [];
      completedTodoList = userTodo.completedTodoList ?? [];
    }
    _calTotalTodo();
    _sortList();
  }

  Future<void> load() async {
    final String? deviceId = await PlatformDeviceId.getDeviceId;
    userCode = deviceId ?? '';
    UserTodoListModel? userTodo = await StorageService.read();
    if (userTodo != null) {
      todoList = userTodo.todoList ?? [];
      completedTodoList = userTodo.completedTodoList ?? [];
    }
    _calTotalTodo();
    _sortList();
    notifyListeners();
  }

  Future<void> searchTodo(String keyword) async {
    searchTodoList = todoList.where((element) => element.todo!.contains(keyword)).toList();
    searchCompletedTodoList = completedTodoList.where((element) => element.todo!.contains(keyword)).toList();

    notifyListeners();
  }

  Future<void> addTodo(TodoListModel todo) async {
    todoList.add(todo);
    _sortList();
    _calTotalTodo();

    await _writeToStorage();
    notifyListeners();
  }

  Future<void> updateTodo(TodoListModel newTodo) async {
    if (newTodo.completed == true) {
      completedTodoList[completedTodoList.indexWhere(
        (element) => element.id == newTodo.id,
      )] = newTodo;
    } else {
      todoList[todoList.indexWhere(
        (element) => element.id == newTodo.id,
      )] = newTodo;
    }

    _sortList();
    await _writeToStorage();
    notifyListeners();
  }

  Future<void> deleteTodo() async {
    todoList = todoList.where((todo) => todo.isSelected == false).toList();
    completedTodoList = completedTodoList.where((todo) => todo.isSelected == false).toList();

    _calTotalTodo();
    await _writeToStorage();
    notifyListeners();
  }

  Future<void> selectAll({bool cancel = false}) async {
    todoList = todoList.map((e) => e.copyWith(isSelected: !cancel)).toList();
    completedTodoList = completedTodoList.map((e) => e.copyWith(isSelected: !cancel)).toList();

    _sortList();
    await _writeToStorage();
    notifyListeners();
  }

  Future<void> markStatus({required TodoListModel todo, required bool completed}) async {
    if (completed) {
      completedTodoList.add(todo.copyWith(completed: true));
      todoList.remove(todo);
    } else {
      todoList.add(todo.copyWith(completed: false));
      completedTodoList.remove(todo);
    }

    _sortList();
    await _writeToStorage();
    notifyListeners();
  }

  Future<void> _writeToStorage() async {
    UserTodoListModel userTodo = UserTodoListModel(
      todoList: todoList,
      completedTodoList: completedTodoList,
    );
    if (isOnline) {
      await FirebaseService.addData(userTodo, userCode);
    } else {
      await StorageService.write(userTodo);
    }
  }

  _calTotalTodo() {
    totalTodo = todoList.length + completedTodoList.length;
  }

  _sortList() {
    todoList.sort((a, b) => b.id!.compareTo(a.id!));
    completedTodoList.sort((a, b) => b.id!.compareTo(a.id!));
  }

  Future<void> clear() async {
    await StorageService.clear();
    todoList = [];
    completedTodoList = [];
    notifyListeners();
  }
}

final todoListProvider = ChangeNotifierProvider<TodoListProvider>(
  create: (context) => TodoListProvider()..load(),
);

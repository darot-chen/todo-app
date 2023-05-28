import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_challenge/model/todo_list_model.dart';
import 'package:todo_app_challenge/model/user_todo_list_model.dart';
import 'package:todo_app_challenge/service/storage_service.dart';

class TodoListProvider extends ChangeNotifier {
  List<TodoListModel> todoList = [];
  List<TodoListModel> searchTodoList = [];
  List<TodoListModel> completedTodoList = [];
  List<TodoListModel> searchCompletedTodoList = [];

  int totalTodo = 0;

  bool _isEdit = false;
  bool get isEdit => _isEdit;
  set isEdit(bool edit) {
    _isEdit = edit;
    notifyListeners();
  }

  load() async {
    UserTodoListModel? userTodo = await StorageService.read();
    if (userTodo != null) {
      todoList = userTodo.todoList ?? [];
      completedTodoList = userTodo.completedTodoList ?? [];
    }
    _calTotalTodo();
    _sortList();
    notifyListeners();
  }

  searchTodo(String keyword) async {
    searchTodoList = todoList.where((element) => element.todo!.contains(keyword)).toList();
    searchCompletedTodoList = completedTodoList.where((element) => element.todo!.contains(keyword)).toList();

    notifyListeners();
  }

  addTodo(TodoListModel todo) async {
    todoList.add(todo);
    _sortList();
    _calTotalTodo();

    await _writeToStorage();
    notifyListeners();
  }

  updateTodo(TodoListModel newTodo) async {
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

  deleteTodo() async {
    todoList = todoList.where((todo) => todo.isSelected == false).toList();
    completedTodoList = completedTodoList.where((todo) => todo.isSelected == false).toList();

    _calTotalTodo();
    await _writeToStorage();
    notifyListeners();
  }

  selectAll({bool cancel = false}) async {
    todoList = todoList.map((e) => e.copyWith(isSelected: !cancel)).toList();
    completedTodoList = completedTodoList.map((e) => e.copyWith(isSelected: !cancel)).toList();

    _sortList();
    await _writeToStorage();
    notifyListeners();
  }

  markStatus({required TodoListModel todo, required bool completed}) async {
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

  _writeToStorage() async {
    UserTodoListModel userTodo = UserTodoListModel(
      todoList: todoList,
      completedTodoList: completedTodoList,
    );

    await StorageService.write(userTodo);
  }

  _calTotalTodo() {
    totalTodo = todoList.length + completedTodoList.length;
  }

  _sortList() {
    todoList.sort((a, b) => b.id!.compareTo(a.id!));
    completedTodoList.sort((a, b) => b.id!.compareTo(a.id!));
  }

  clear() async {
    await StorageService.clear();
    todoList = [];
    completedTodoList = [];
    notifyListeners();
  }
}

final todoListProvider = ChangeNotifierProvider<TodoListProvider>(
  create: (context) => TodoListProvider()..load(),
);

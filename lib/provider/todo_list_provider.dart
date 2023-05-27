import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_challenge/model/todo_list_model.dart';
import 'package:todo_app_challenge/model/user_todo_list_model.dart';
import 'package:todo_app_challenge/service/storage_service.dart';

class TodoListProvider extends ChangeNotifier {
  List<TodoListModel> todoList = [];
  List<TodoListModel> completedTodoList = [];

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
    notifyListeners();
  }

  addTodo(TodoListModel todo) async {
    todoList.add(todo);
    _sortList();
    _calTotalTodo();

    await _writeToStorage();
    notifyListeners();
  }

  updateTodo(TodoListModel newTodo, TodoListModel oldTodo) async {
    if (newTodo.completed == true) {
      completedTodoList.remove(oldTodo);
      completedTodoList.add(newTodo);
    } else {
      todoList.remove(oldTodo);
      todoList.add(newTodo);
    }

    _sortList();
    await _writeToStorage();
    notifyListeners();
  }

  deleteTodo(TodoListModel todo) {
    todoList.remove(todo);
    _calTotalTodo();
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

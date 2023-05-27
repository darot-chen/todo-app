import 'dart:convert';
import 'package:todo_app_challenge/model/todo_list_model.dart';

UserTodoListModel userTodoListFromJson(String str) => UserTodoListModel.fromJson(json.decode(str));

String userTodoListToJson(UserTodoListModel data) => json.encode(data.toJson());

class UserTodoListModel {
  List<TodoListModel>? todoList;
  List<TodoListModel>? completedTodoList;

  UserTodoListModel({
    this.todoList,
    this.completedTodoList,
  });

  UserTodoListModel copyWith({
    List<TodoListModel>? todoList,
    List<TodoListModel>? completedTodoList,
  }) =>
      UserTodoListModel(
        todoList: todoList ?? this.todoList,
        completedTodoList: completedTodoList ?? this.completedTodoList,
      );

  factory UserTodoListModel.fromJson(Map<String, dynamic> json) => UserTodoListModel(
        todoList: json["todoList"] == null
            ? []
            : List<TodoListModel>.from(json["todoList"]!.map((x) => TodoListModel.fromJson(x))),
        completedTodoList: json["completedTodoList"] == null
            ? []
            : List<TodoListModel>.from(json["completedTodoList"]!.map((x) => TodoListModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "todoList": todoList == null ? [] : List<dynamic>.from(todoList!.map((x) => x.toJson())),
        "completedTodoList":
            completedTodoList == null ? [] : List<dynamic>.from(completedTodoList!.map((x) => x.toJson())),
      };
}

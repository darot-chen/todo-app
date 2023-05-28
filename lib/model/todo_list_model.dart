import 'dart:convert';

List<TodoListModel> todoListModelFromJson(String str) =>
    List<TodoListModel>.from(json.decode(str).map((x) => TodoListModel.fromJson(x)));

String todoListModelToJson(List<TodoListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TodoListModel {
  int? id;
  String? todo;
  bool completed;
  bool isSelected;

  TodoListModel({
    this.id,
    this.todo,
    this.completed = false,
    this.isSelected = false,
  });

  TodoListModel copyWith({
    int? id,
    String? todo,
    bool? completed,
    bool? isSelected,
  }) =>
      TodoListModel(
        id: id ?? this.id,
        todo: todo ?? this.todo,
        completed: completed ?? this.completed,
        isSelected: isSelected ?? this.isSelected,
      );

  factory TodoListModel.fromJson(Map<String, dynamic> json) => TodoListModel(
        id: json["id"],
        todo: json["todo"],
        completed: json["completed"],
        isSelected: json["isSelected"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "todo": todo,
        "completed": completed,
        "isSelected": isSelected,
      };
}

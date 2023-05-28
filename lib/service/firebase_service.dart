import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app_challenge/model/user_todo_list_model.dart';

class FirebaseService {
  static Future<void> addData(UserTodoListModel userTodo) {
    var db = FirebaseFirestore.instance;

    return db
        .collection("data")
        .doc("user2")
        .set(
          userTodo.toJson(),
          SetOptions(merge: true),
        )
        .then((value) => print("Data Added"))
        .catchError((error) => print("Failed to add data: $error"));
  }
}

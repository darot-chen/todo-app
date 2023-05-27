import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_challenge/model/user_todo_list_model.dart';

const String _storageKey = 'userTodo';

class StorageService {
  static Future<void> write(
    UserTodoListModel data,
  ) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setString(_storageKey, userTodoListToJson(data));
  }

  static Future<UserTodoListModel?>? read() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    final String? result = pref.getString(_storageKey);
    if (result == null) return null;

    return userTodoListFromJson(result);
  }

  static Future<void> clear() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove(_storageKey);
  }
}

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_challenge/model/user_model.dart';

String _userModelKey = 'todo_app_user_list';

class UserListStorage {
  static Future<void> write(
    UserModel data,
  ) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setString(_userModelKey, userModelToJson(data));
  }

  static Future<UserModel?>? read() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    final String? result = pref.getString(_userModelKey);
    if (result == null) return null;

    return userModelFromJson(result);
  }

  static Future<void> clear() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove(_userModelKey);
  }
}

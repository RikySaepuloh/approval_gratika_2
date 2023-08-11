import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static Future<void> saveLoginToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('loginToken', token);
  }

  static Future<void> saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  static Future<void> savePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', password);
  }

  static Future<String?> getLoginToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('loginToken');
  }

  static Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<String?> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('password');
  }

  static Future<void> clearLoginToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('loginToken');
  }
}
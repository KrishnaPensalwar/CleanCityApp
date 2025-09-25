import 'dart:convert';

import 'package:cleancity/data/model/User.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const String userKey = "user";

  static Future<void> saveUserToSharedPref(User user) async {
    final sharedPref = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user);

    await sharedPref.setString(userKey, jsonString);
  }

  static Future<User?> loadUserFromSharedPref() async {
    final sharedPref = await SharedPreferences.getInstance();
    final jsonString = sharedPref.getString(userKey);
    final logger = Logger();

    if (jsonString == null) {
      return null;
    }
    return User.fromJson(jsonDecode(jsonString));
  }

  static Future<void> removeUserFromSharedPref() async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.remove(userKey);
  }
}

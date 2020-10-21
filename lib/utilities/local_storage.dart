import 'dart:convert';

import 'package:couchya/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<String> getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    print(token);
    return token ?? '';
  }

  static setToken(token) async {
    print('setting token');
    print(token);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString('token', token);
  }

  static setUser(user) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString('user', jsonEncode(user));
  }

  static Future<User> getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString('user') != null
        ? User.fromJson(json.decode(localStorage.getString('user')))
        : null;
    return user;
  }

  static destroyUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.remove('user');
  }

  static destroyToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.remove('token');
  }
}

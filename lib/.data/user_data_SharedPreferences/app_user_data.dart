import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../models/user_models.dart';

// class shared_Preferences {
class Prefs {
  String username = "username";
  String token = "token";
  String email = "email";
  String pass = "password";


  // Future<String> getName() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('username') ?? '';
  // }
  //
  // void saveName(String name) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('username', name);
  // }

  Future<String> get(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  void set(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}

class UserDataProvider extends ChangeNotifier {
  Users? _userData;

  Users? get userData => _userData;

  void saveUserData(Users data) {
    _userData = data;
    notifyListeners();
  }
}

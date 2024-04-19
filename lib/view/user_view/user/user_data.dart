import 'dart:convert';

import 'package:flutter_women_safety_app/view_models/user_view_model/UserViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/user_model.dart';

class UserData {
  static late SharedPreferences _preferences;
  static const _keyUser = 'user';

  static Users myUser = Users(
      imageUrl: "https://upload.wikimedia.org/wikipedia/en/0/0b/Darth_Vader_in_The_Empire_Strikes_Back.jpg",
      name: 'Test Test',
      email: 'test.test@gmail.com',
      phone: 44,
      longitude: 85,
      latitude: 48,
      securityCode: 'sfsddf4');

  static Future init() async => _preferences = await SharedPreferences.getInstance();

  static Future setUser(Users user) async {
    await init();
    final json = jsonEncode(user.toJson());
    await _preferences.setString(_keyUser, json);

    UserViewModel().patchUserApi(user.phone);
  }

  static Future<Users> getUser() async {
    await init();
    final json = _preferences.getString(_keyUser);
    return json == null ? myUser : Users.fromJson(jsonDecode(json));
  }
}

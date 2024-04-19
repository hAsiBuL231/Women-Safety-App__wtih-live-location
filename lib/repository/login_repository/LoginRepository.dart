import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_women_safety_app/.data/user_data_SharedPreferences/app_user_data.dart';

import '../../.data/network/network_api_services.dart';
import '../../.resources/app_url/AppUrl.dart';
import '../../.utils/Functions.dart';

class LoginRepository {
  final _apiServices = NetworkApiServices();

  Future<dynamic> loginApi(var data, context) async {
    String jsonData = json.encode(data);
    dynamic response = await _apiServices.postApi(jsonData, AppUrl.loginUrl);
    String jsonResponse = json.encode(response);
    saveUserData(data, response, context);
    return jsonResponse;
  }

  Future<dynamic> registerApi(var data, context) async {
    String jsonData = json.encode(data);
    dynamic response = await _apiServices.postApi(jsonData, AppUrl.registerUrl);
    String jsonResponse = json.encode(response);
    saveUserData(data, response, context);
    return jsonResponse;
  }

  saveUserData(data, response, context) async {
    if (kDebugMode) {
      print("\n /////////////////////////////////////////////// loginApi Printing ////////////////////////// \n ");
      //print("Returned statusCode: ${response.statusCode} \n");
      print(response['token']);
      print(response);
      print("\n /////////////////////////////////////////////// loginApi Printed ////////////////////////// \n ");
    }

    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setString('username', data['username']);
      // await prefs.setString('token', response['token']);
      Prefs prefs = Prefs();
      prefs.set(prefs.username, data['username']);
      prefs.set(prefs.token, response['token']);
      prefs.set(prefs.email, response['user']['email']);
    } catch (e) {
      showToast("Failed to save preferences: $e", error: true);
    }
  }
}

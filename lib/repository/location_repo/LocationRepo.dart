import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/.data/user_data_SharedPreferences/app_user_data.dart';

import '../../.data/network/network_api_services.dart';
import '../../.resources/app_url/AppUrl.dart';
import '../../.utils/Functions.dart';

class LocationRepo {
  final _apiServices = NetworkApiServices();

  Future<dynamic> getAllUserLocationApi(context) async {
    // String jsonData = json.encode(data);
    dynamic response = await _apiServices.getApi(AppUrl.locationUrl);
    String jsonResponse = json.encode(response);
    // saveUserData(data, response, context);
    return jsonResponse;
  }

  Future<dynamic> getUserLocationApi(String securityCode, BuildContext context) async {
    try {
      dynamic response = await _apiServices.getApi("${AppUrl.locationUrl}$securityCode/");
      String jsonResponse = json.encode(response);
      return jsonResponse;
    } catch (e) {
      showToast("Loc: ${e.toString()}", error: true);
    }
  }

  Future<dynamic> postUserLocationApi(var data, BuildContext context) async {
    Prefs prefs = Prefs();
    String token = await prefs.get(prefs.token);
    String email = await prefs.get(prefs.email);

    Map data = {"token": token, "taker": email, "message": "Please enter your name", "latitude": 0, "longitude": 0};
    try {
      String jsonData = json.encode(data);
      dynamic response = await _apiServices.postApi(jsonData, "${AppUrl.locationUrl}/$token");
      String jsonResponse = json.encode(response);
      snackBar('User Location Created', context);
      return jsonResponse;
    } catch (e) {
      showToast("Loc: ${e.toString()}", error: true);
    }
    // Users user = await prefs.get("user");
    // String? securityCode = UserDataProvider().userData?.securityCode;
  }

  Future<dynamic> patchUserLocationApi() async {
    Prefs prefs = Prefs();
    String token = await prefs.get(prefs.token);
    // Users user = await prefs.get("user");
    // String? securityCode = UserDataProvider().userData?.securityCode;
    Map data = {"latitude": 0, "longitude": 0};

    try {
      String jsonData = json.encode(data);
      dynamic response = await _apiServices.patchApi(jsonData, "${AppUrl.locationUrl}$token/");
      return response;
    } catch (e) {
      showToast("Loc: ${e.toString()}", error: true);
    }
  }
}

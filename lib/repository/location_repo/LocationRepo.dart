import 'dart:convert';

import 'package:geolocator/geolocator.dart';
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
      showToast("Loc getUser: ${e.toString()}", error: true);
    }
  }

  Future<dynamic> postUserLocationApi(BuildContext context) async {
    Prefs prefs = Prefs();
    String token = await prefs.get(prefs.token);
    String username = await prefs.get(prefs.username);

    Position? position = await Geolocator.getLastKnownPosition();

    Map data = {"token": token, "taker": username, "message": "Please enter your name", "latitude": position!.latitude, "longitude": position.longitude};
    try {
      String jsonData = json.encode(data);
      dynamic response = await _apiServices.postApi(jsonData, AppUrl.locationUrl);
      String jsonResponse = json.encode(response);
      snackBar('User Location Created', context);
      return jsonResponse;
    } catch (e) {
      showToast("Loc postUser: ${e.toString()}", error: true);
    }
    // Users user = await prefs.get("user");
    // String? securityCode = UserDataProvider().userData?.securityCode;
  }

  Future<dynamic> patchUserLocationApi(data) async {
    Prefs prefs = Prefs();
    String token = await prefs.get(prefs.token);
    // Users user = await prefs.get("user");
    // String? securityCode = UserDataProvider().userData?.securityCode;
    // Map data = {"latitude": 0, "longitude": 0};

    try {
      String jsonData = json.encode(data);
      dynamic response = await _apiServices.patchApi(jsonData, "${AppUrl.locationUrl}$token/");
      return response;
    } catch (e) {
      showToast("Loc patchUser: ${e.toString()}", error: true);
    }
  }
}

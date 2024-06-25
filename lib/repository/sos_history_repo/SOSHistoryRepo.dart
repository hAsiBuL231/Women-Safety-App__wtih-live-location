import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/.data/user_data_SharedPreferences/app_user_data.dart';

import '../../.data/network/network_api_services.dart';
import '../../.resources/app_url/AppUrl.dart';
import '../../.utils/Functions.dart';

class SOSHistoryRepo {
  final _apiServices = NetworkApiServices();

  Future<dynamic> getAllUserSOSHistoryApi(context) async {
    // String jsonData = json.encode(data);
    dynamic response = await _apiServices.getApi(AppUrl.sos_history);
    String jsonResponse = json.encode(response);
    // saveUserData(data, response, context);
    return response;
  }

  Future<dynamic> getUserSOSHistoryApi(String securityCode, BuildContext context) async {
    try {
      dynamic response = await _apiServices.getApi("${AppUrl.sos_history}$securityCode/");
      String jsonResponse = json.encode(response);
      return response;
    } catch (e) {
      showToast("Loc getUser: ${e.toString()}", error: true);
    }
  }

  Future<dynamic> postUserSOSHistoryApi() async {
    Prefs prefs = Prefs();
    String token = await prefs.get(prefs.token);
    String username = await prefs.get(prefs.username);
    String useremail = await prefs.get(prefs.email);
    int usernumber = await prefs.getInt(prefs.user_number);

    Position? position = await Geolocator.getLastKnownPosition();

    Map data = {
      "token": token,
      "name": username,
      "email": useremail,
      "number": usernumber,
      "location": "location",
      "latitude": position!.latitude,
      "longitude": position.longitude,
      "phone_numbers": "phoneNumbers"
    };
    try {
      String jsonData = json.encode(data);
      dynamic response = await _apiServices.postApi(jsonData, AppUrl.sos_history);
      String jsonResponse = json.encode(response);
      return jsonResponse;
    } catch (e) {
      showToast("Loc postUser: ${e.toString()}", error: true);
    }
    // Users user = await prefs.get("user");
    // String? securityCode = UserDataProvider().userData?.securityCode;
  }

  Future<dynamic> patchUserSOSHistoryApi(data) async {
    Prefs prefs = Prefs();
    String token = await prefs.get(prefs.token);
    // Users user = await prefs.get("user");
    // String? securityCode = UserDataProvider().userData?.securityCode;
    // Map data = {"latitude": 0, "longitude": 0};

    try {
      String jsonData = json.encode(data);
      dynamic response = await _apiServices.patchApi(jsonData, "${AppUrl.sos_history}$token/");
      return response;
    } catch (e) {
      showToast("Loc patchUser: ${e.toString()}", error: true);
    }
  }
}

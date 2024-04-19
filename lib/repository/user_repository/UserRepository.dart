import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_women_safety_app/.data/user_data_SharedPreferences/app_user_data.dart';

import '../../.data/network/network_api_services.dart';
import '../../.resources/app_url/AppUrl.dart';
import '../../.utils/Functions.dart';
import '../../models/user_model.dart';

class UserRepository {
  final _apiServices = NetworkApiServices();

  Future<dynamic> getAllUserApi(context) async {
    // String jsonData = json.encode(data);
    dynamic response = await _apiServices.getApi(AppUrl.usersUrl);
    String jsonResponse = json.encode(response);
    // saveUserData(data, response, context);
    return jsonResponse;
  }

  Future<dynamic> getUserApi() async {
    Prefs prefs = Prefs();
    String token = await prefs.get(prefs.token);
    // Users user = await prefs.get("user");
    // String? securityCode = UserDataProvider().userData?.securityCode;

    dynamic response = await _apiServices.getApi("${AppUrl.usersUrl}$token");
    String jsonResponse = json.encode(response);

    // if (kDebugMode) {
    //   print("\n /////////////////////////////////////////////// getUserApi Printing ////////////////////////// \n ");
    //   //print("Returned statusCode: ${response.statusCode} \n");
    //   print(response['token']);
    //   print(response);
    //   print("\n /////////////////////////////////////////////// getUserApi Printed ////////////////////////// \n ");
    // }

    // saveUserData(data, response, context);
    return jsonResponse;
  }

  Future<dynamic> postUserApi(var data) async {
    Prefs prefs = Prefs();
    String token = await prefs.get(prefs.token);
    // Users user = await prefs.get("user");
    // String? securityCode = UserDataProvider().userData?.securityCode;

    String jsonData = json.encode(data);
    dynamic response = await _apiServices.postApi("${AppUrl.usersUrl}/$token", data);
    String jsonResponse = json.encode(response);

    if (kDebugMode) {
      print("\n /////////////////////////////////////////////// getUserApi Printing ////////////////////////// \n ");
      //print("Returned statusCode: ${response.statusCode} \n");
      print(response['token']);
      print(response);
      print("\n /////////////////////////////////////////////// getUserApi Printed ////////////////////////// \n ");
    }

    // saveUserData(data, response, context);
    return jsonResponse;
  }

  Future<dynamic> patchUserApi(var data) async {
    Prefs prefs = Prefs();
    String token = await prefs.get(prefs.token);
    // Users user = await prefs.get("user");
    // String? securityCode = UserDataProvider().userData?.securityCode;

    String jsonData = json.encode(data);
    dynamic response = await _apiServices.patchApi("${AppUrl.usersUrl}$token/", jsonData);

    if (kDebugMode) {
      print("\n /////////////////////////////////////////////// getUserApi Printing ////////////////////////// \n ");
      //print("Returned statusCode: ${response.statusCode} \n");
      print(response['token']);
      print(response);
      print("\n /////////////////////////////////////////////// getUserApi Printed ////////////////////////// \n ");
    }

    // saveUserData(data, response, context);
    return response;
  }
}

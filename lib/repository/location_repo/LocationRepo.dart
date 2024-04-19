import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_women_safety_app/.data/user_data_SharedPreferences/app_user_data.dart';

import '../../.data/network/network_api_services.dart';
import '../../.resources/app_url/AppUrl.dart';

class LocationRepo {
  final _apiServices = NetworkApiServices();

  Future<dynamic> getAllUserLocationApi(context) async {
    // String jsonData = json.encode(data);
    dynamic response = await _apiServices.getApi(AppUrl.locationUrl);
    String jsonResponse = json.encode(response);
    // saveUserData(data, response, context);
    return jsonResponse;
  }

  Future<dynamic> getUserLocationApi() async {
    Prefs prefs = Prefs();
    String token = await prefs.get(prefs.token);
    // Users user = await prefs.get("user");
    // String? securityCode = UserDataProvider().userData?.securityCode;

    dynamic response = await _apiServices.getApi("${AppUrl.locationUrl}$token");
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

  Future<dynamic> postUserLocationApi(var data) async {
    Prefs prefs = Prefs();
    String token = await prefs.get(prefs.token);
    // Users user = await prefs.get("user");
    // String? securityCode = UserDataProvider().userData?.securityCode;

    String jsonData = json.encode(data);
    dynamic response = await _apiServices.postApi("${AppUrl.locationUrl}/$token", data);
    String jsonResponse = json.encode(response);

    if (kDebugMode) {
      print("\n /////////////////////////////////////////////// postUserLocationApi Printing ////////////////////////// \n ");
      //print("Returned statusCode: ${response.statusCode} \n");
      print(response['token']);
      print(response);
      print("\n /////////////////////////////////////////////// postUserLocationApi Printed ////////////////////////// \n ");
    }

    // saveUserData(data, response, context);
    return jsonResponse;
  }

  Future<dynamic> patchUserLocationApi(var data) async {
    Prefs prefs = Prefs();
    String token = await prefs.get(prefs.token);
    // Users user = await prefs.get("user");
    // String? securityCode = UserDataProvider().userData?.securityCode;

    String jsonData = json.encode(data);
    dynamic response = await _apiServices.patchApi("${AppUrl.locationUrl}$token/", jsonData);

    if (kDebugMode) {
      print("\n /////////////////////////////////////////////// patchUserLocationApi Printing ////////////////////////// \n ");
      //print("Returned statusCode: ${response.statusCode} \n");
      print(response['token']);
      print(response);
      print("\n /////////////////////////////////////////////// patchUserLocationApi Printed ////////////////////////// \n ");
    }

    // saveUserData(data, response, context);
    return response;
  }
}

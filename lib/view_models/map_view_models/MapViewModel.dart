import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../.data/user_data_SharedPreferences/app_user_data.dart';
import '../../.utils/Functions.dart';

import '../../repository/location_repo/LocationRepo.dart';

class MapViewModel extends GetxController {
  final _api = LocationRepo();

  Future<dynamic> getUserLocationApi(context) async {
    var response;
    try {
      response = await _api.getUserLocationApi();
      snackBar('Get User Location data successful', context);
    } catch (e) {
      showToast("Loc: ${e.toString()}", error: true);
    }
    return response;
  }

  Future<void> postUserLocationApi(context) async {
    Prefs prefs = Prefs();
    String token = await prefs.get(prefs.token);
    String email = await prefs.get(prefs.email);

    Map data = {"token": token, "taker": email, "message": "Please enter your name", "latitude": 0, "longitude": 0};

    try {
      var response = await _api.postUserLocationApi(data);
      snackBar('User Location Created', context);
    } catch (e) {
      showToast("sf: ${e.toString()}", error: true);
    }
  }

  Future<void> patchUserLocationApi(int phone) async {
    Prefs prefs = Prefs();
    String token = await prefs.get(prefs.token);
    String email = await prefs.get(prefs.email);

    Map data = {"latitude": 0, "longitude": 0};

    try {
      var response = await _api.patchUserLocationApi(data);
    } catch (e) {
      showToast("Loc: ${e.toString()}", error: true);
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../.data/network/network_api_services.dart';
import '../../.resources/app_url/AppUrl.dart';
import '../../.utils/Functions.dart';
import '../../models/group_model.dart';

class AddMemberFormVM extends GetxController {
  Rx<TextEditingController> securityCodeController = TextEditingController().obs;
  final GlobalKey<FormState> addMemberFormKey = GlobalKey<FormState>();

  Future<void> submitForm(Group passedGroup, BuildContext context) async {
    if (addMemberFormKey.currentState!.validate()) {
      try {
        await NetworkApiServices().getApi(AppUrl.usersUrl).then((value) async {
          List response = value['results'];
          print(" \n \n AddMemberFormVM Print: $value , \n response= $response \n ");

          bool tag = false;
          String secCode = securityCodeController.value.text;

          for (var users in response) {
            print(" \n  AddMemberFormVM Print: ${users['securityCode']} == $secCode \n ");
            // Check if the user exists...
            if (users['securityCode'] == secCode) tag = true;
          }

          // List matchedUsers2 = response.where((users) => users['securityCode'] == securityCodeController.value).toList();

          if (tag) {
            String newMemberUrl = "${AppUrl.usersUrl}${securityCodeController.value.text}/";

            if (passedGroup.users.contains(newMemberUrl)) {
              showToast("Member already exists!", error: true);
            } else {
              passedGroup.users.add(newMemberUrl);
              Map data = {"users": passedGroup.users};
              String jsonData = json.encode(data);
              NetworkApiServices().patchApi(jsonData, passedGroup.groupId).then((value) => const SnackBar(content: Text('Data added')));
            }
          } else {
            showToast("User does not exists with this securityCode.", error: true);
          }
        });

        // Clear the form fields
      } catch (e) {
        showToast(e.toString(), error: true);
      }
      securityCodeController.value.clear();
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }
}

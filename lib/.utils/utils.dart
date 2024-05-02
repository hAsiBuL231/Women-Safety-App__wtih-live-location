import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter_women_safety_app/.resources/colours/app_colours.dart';
import 'package:flutter_women_safety_app/view/Authentication/login_view/LoginPageView.dart';

class Utils {
  static void fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static showToast(String message) {
    Fluttertoast.showToast(msg: message, backgroundColor: AppColors.blackColour, gravity: ToastGravity.BOTTOM);
  }

  static snackBar(String title, String message) {
    Get.snackbar(title, message);
    //Get.snackbar('title', 'message', snackPosition: SnackPosition.BOTTOM, colorText: Colors.white, backgroundColor: Colors.black, borderColor: Colors.white);
  }

  static bottomSheet(String message) {
    Get.bottomSheet(Container(
      height: 150,
      color: AppColors.spaceBlue,
      child: Center(child: Text(message, style: const TextStyle(fontSize: 28.0, color: Colors.white))),
    ));
  }

  static dialogs(String title, String message) {
    Get.defaultDialog(
      radius: 10.0,
      contentPadding: const EdgeInsets.all(20.0),
      title: title,
      middleText: message,
      textConfirm: 'Okay',
      confirm: OutlinedButton.icon(
          onPressed: () => Get.back(), icon: const Icon(Icons.check_circle, color: Colors.blue), label: const Text('Okay', style: TextStyle(color: Colors.blue))),
      cancel: OutlinedButton.icon(onPressed: () {}, icon: Icon(Icons.cancel), label: Text("Cancel")),
    );
  }
}

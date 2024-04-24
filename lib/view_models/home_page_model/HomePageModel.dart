import 'dart:convert';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../.data/network/network_api_services.dart';
import '../../.data/user_data_SharedPreferences/app_user_data.dart';
import '../../.resources/app_url/AppUrl.dart';
import '../../.utils/utils.dart';
import '../../models/user_model.dart';
import '../map_view_models/location_model/listen_location.dart';

class HomePageModel extends GetxController {
  RxBool switchListTileValue = false.obs;
  Prefs prefs = Prefs();

  getLiveLocPer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switchListTileValue.value = prefs.getBool('locPer')!;
    if (switchListTileValue.isTrue) {
      ListenLocationProvider prov = Get.put(ListenLocationProvider());
      prov.startListening();
    }
  }

  requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Utils.snackBar('Location', 'Location Permission Granted');
      //showToast('Location Permission Granted');
      //print(" \n \n Location Permission is Granted \n \n ");
    } else if (status.isDenied) {
      Utils.snackBar('Location', 'Location Permission is Denied');
      //showToast('Location Permission is Denied');
      //print(" \n \n Location Permission is Denied \n \n ");
      // requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  /// For HomePage User load data
  Future<void> loadData(context) async {
    NetworkApiServices().getApi(AppUrl.usersUrl).then((value) async {
      final provider = Provider.of<UserDataProvider>(context, listen: false);
      var userEmail = await prefs.get(prefs.email) ?? '';

      var response = value['results'];
      // var users = [];
      // response.map((doc) {
      //   print(doc);
      //   users.add(Users.fromJson(doc));
      // });
      print(" \n \n HomePageModel loadData Print: $response , userEmail= $userEmail \n ");

      var matchedUsers = response.where((users) => users['email'] == userEmail).toList();
      Users user = Users.fromJson(matchedUsers[0]);
      print(" \n HomePageModel loadData Print: ${user.securityCode} \n \n ");

      UserDataProvider().saveUserData(user);

      //Provider.of<UserDataProvider>(context, listen: false).saveUserData(user);

      SharedPreferences _preferences = await SharedPreferences.getInstance();
      final json = jsonEncode(user.toJson());
      await _preferences.setString('user', json);

      provider.saveUserData(user);
    });
  }

  /// LocationModel
  // final locationVM = Get.put(LocationModel());
  // getCurrentLocation(context) {
  //   locationVM.getCurrentLocation(context);
  // }
  //
  // getAddressFromLatLon() {
  //   locationVM.getAddressFromLatLon();
  // }
  //
  // handleLocationPermission(context) {
  //   locationVM.handleLocationPermission(context);
  // }

  /// ListenLocationProvider
  // final listenLocationVM = Get.put(ListenLocationProvider());
  //
  // listenLocation(BuildContext context) {
  //   listenLocationVM.listenLocation(context);
  // }
  //
  // stopListening() {
  //   listenLocationVM.stopListening();
  // }

  /// SmsModel
  // final smsVM = Get.put(SmsModel());
  //
  // shakeInitialization() {
  //   smsVM.shakeInitialization();
  // }
  //
  // sendSms(String phoneNumber, String message, {int? simSlot}) {
  //   smsVM.sendSms(phoneNumber, message);
  // }
  //
  // getAndSendSMS() {
  //   smsVM.getAndSendSMS();
  // }
}

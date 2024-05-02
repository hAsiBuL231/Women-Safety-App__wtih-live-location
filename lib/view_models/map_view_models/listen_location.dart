import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repository/location_repo/LocationRepo.dart';

class ListenLocationProvider extends GetxController {
  //final Location location = Location();
  //StreamSubscription<LocationData>? _locationSubscription;

  RxBool listen = false.obs;

  final Rx<AndroidSettings> locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
      // forceLocationManager: true,
      intervalDuration: const Duration(seconds: 2),
      //(Optional) Set foreground notification config to keep the app alive when going to the background
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationText: "TrackLive app will continue to receive your location even when you aren't using it",
        notificationTitle: "Running in Background",
        enableWakeLock: true,
      )).obs;

  // created method for getting user current location
  Future<void> listenLocation(BuildContext context) async {
    if (listen.isTrue) {
      Geolocator.getServiceStatusStream().listen((ServiceStatus status) async {
        if (status == ServiceStatus.disabled) {
          await Geolocator.requestPermission();
          // await Geolocator.openAppSettings();
          // await Geolocator.openLocationSettings();
        }
        print(" \n  serviceStatusStream: $status \n  ");
      });

      Geolocator.getPositionStream(locationSettings: locationSettings.value).listen((Position? position) {
        print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
        LocationRepo locationApi = LocationRepo();

        if (position != null) {
          Map data = {"latitude": position.latitude, "longitude": position.longitude};

          /// Implement save data in the server
          locationApi.patchUserLocationApi(data);
        }
      });
    }

    // _locationSubscription = location.onLocationChanged.handleError((onError) {
    //   print(" \n \n \n _listenLocation Error: \n $onError \n \n \n ");
    //   //print(onError);
    //   _locationSubscription?.cancel();
    //   //setState(() => _locationSubscription = null);
    //   _locationSubscription = null;
    // }).listen((LocationData currentLocation) async {
    //   final userProvider = Provider.of<UserDataProvider>(context, listen: false);

    //Users? user;

    /// /////////////////////////////////// Finding the user data   //////////////////////////////
    /*var provider = Provider.of<UserDataProvider>(context, listen: false);
      await NetworkApiServices().getApi(AppUrl.userCollectionUrl).then((value) {
        String? userEmail = FirebaseAuth.instance.currentUser!.email;
        var response = value['documents'];
        var users = response.map((doc) => Users.fromJson(doc));
        var matchedUsers = users.where((users) => users.email == userEmail).toList();
        user = matchedUsers[0];
        print(" \n \n Print2: ${user!.securityCode} \n \n ");
      });*/

    /// /////////////////////////////////// Finding the user data   //////////////////////////////
    // //if (user != null) {
    // await FirebaseFirestore.instance.collection('User').doc(userProvider.userData!.securityCode).collection('location').doc('lat-long').set({
    //   'latitude': currentLocation.latitude,
    //   'longitude': currentLocation.longitude,
    //   //'Location': currentLocation,
    // }, SetOptions(merge: true));
    // //}
    // //showToast('_listenLocation Successful');
    //});
  }

  // getListing() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   listen.value = prefs.getBool('locPer')!;
  // }

  startListening() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('locPer', true);
    listen.value = true;
  }

  stopListening() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('locPer', false);
    listen.value = false;
    //_locationSubscription?.cancel();
    //setState(() => _locationSubscription = null);
    //_locationSubscription = null;
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repository/location_repo/LocationRepo.dart';

class ListenLocationProvider extends GetxController {
  //final Location location = Location();
  //StreamSubscription<LocationData>? _locationSubscription;

  @override
  void onReady() {
    // startTimer();
    super.onReady();
  }

  @override
  void onClose() {
    //if (timer != null) {
    //  timer!.cancel();
    //}
    _positionStreamSubscription?.cancel();
    listen.value = false;
    super.onClose();
  }

  RxBool listen = false.obs;
  //Timer? timer;
  LocationRepo locationApi = LocationRepo();
  StreamSubscription<Position>? _positionStreamSubscription;

  final Rx<AndroidSettings> locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
      // forceLocationManager: true,
      intervalDuration: const Duration(seconds: 50),
      //(Optional) Set foreground notification config to keep the app alive when going to the background
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationText: "TrackLive app will continue to receive your location even when you aren't using it",
        notificationTitle: "Running in Background",
        enableWakeLock: true,
      )).obs;

  // created method for getting user current location
  /*Future<void> listenLocation(BuildContext context) async {
    if (listen.isTrue) {
      print("listen location");
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
  }*/

  /*startTimer() {
    timer = Timer.periodic(
      const Duration(minutes: 1),
      (Timer timer) {
        print("Timer running ${timer.tick}");
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

          if (position != null) {
            Map data = {"latitude": position.latitude, "longitude": position.longitude};

            print("getPositionStream: ${data}");

            /// Implement save data in the server
            locationApi.patchUserLocationApi(data);
          }
        }, onError: (error) {
          print("getPositionStream: failed with error: $error");
        });
        //print("getPositionStream: failed");
        ///////// function end ////
      },
    );
  }*/

  void startRepeatedTask() {
    const duration = Duration(seconds: 50);

    void callTask() async {
      if (!listen.value) return; // Stop if flag is false
      await Future.delayed(duration);
      task();
      callTask();
    }

    callTask();
  }

  void task() {
    Geolocator.getServiceStatusStream().listen((ServiceStatus status) async {
      if (status == ServiceStatus.disabled) {
        await Geolocator.requestPermission();
        // await Geolocator.openAppSettings();
        // await Geolocator.openLocationSettings();
      }
      print(" \n  serviceStatusStream: $status \n  ");
    });

    _positionStreamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings.value).listen((Position? position) async {
      print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');

      if (position != null) {
        Map data = {"latitude": position.latitude, "longitude": position.longitude};

        print("getPositionStream: ${data}");

        /// Implement save data in the server
        await Future.delayed(const Duration(seconds: 50));
        await locationApi.patchUserLocationApi(data);
      }
    }, onError: (error) {
      print("getPositionStream: failed with error: $error");
    });
  }

  // getListing() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   listen.value = prefs.getBool('locPer')!;
  // }

  startListening() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('locPer', true);
    listen.value = true;
    startRepeatedTask();
    update();
  }

  stopListening() async {
    // if (timer != null) {
    //   timer!.cancel();
    // }
    _positionStreamSubscription?.cancel();
    onClose();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('locPer', false);
    listen.value = false;
    update();
    //_locationSubscription?.cancel();
    //setState(() => _locationSubscription = null);
    //_locationSubscription = null;
  }
}

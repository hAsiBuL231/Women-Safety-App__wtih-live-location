import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ListenLocationProvider extends GetxController {
  //final Location location = Location();
  //StreamSubscription<LocationData>? _locationSubscription;

  // created method for getting user current location
  Future<void> listenLocation(BuildContext context) async {
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

  stopListening() {
    //_locationSubscription?.cancel();
    //setState(() => _locationSubscription = null);
    //_locationSubscription = null;
  }
}

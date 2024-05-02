import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../.utils/Functions.dart';

class MapViewModel extends GetxController {
  /// Declarations
  Position currentPosition = Position(
      latitude: 22.366577,
      longitude: 91.831600,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      altitudeAccuracy: 1,
      heading: 2,
      headingAccuracy: 2,
      speed: 2,
      speedAccuracy: 2);

  RxString currentAddress = "".obs;

  LocationPermission permission = LocationPermission.always;

  RxList<Marker> markers = <Marker>[].obs;

  LatLng currentP = const LatLng(0, 0);
  final LatLng _pGooglePlex = const LatLng(37.4223, -122.0848);
  Map<PolylineId, Polyline> polylines = {};

  /// Functions
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {
      print(" \n Value: $value \n ");
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print(" \n ERROR: $error \n ");
    });
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, forceAndroidLocationManager: true);
  }

  // on pressing floating action button the camera will take to user current location
  // returnToCurrLoc(List<Marker> markers, Completer<GoogleMapController> mapController)
  returnToCurrLoc(Completer<GoogleMapController> mapController) async {
    try {
      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((position) async {
        currentP = LatLng(position.latitude, position.longitude);
        print(" \n \n currentPosition; $position  ::   $currentP \n \n ");
        getAddressFromLatLon();

        // marker added for current users location
        // markers.add(Marker(
        //   markerId: const MarkerId("1"),
        //   position: LatLng(position.latitude, position.longitude),
        //   infoWindow: const InfoWindow(title: 'My Current Location'),
        // ));

        // specified current users location
        CameraPosition cameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14);
        final GoogleMapController controller = await mapController.future;
        await controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      });
    } catch (e) {
      print(" \n \n currentPosition Error: ${e.toString()}  \n \n ");
    }
  }

  getCurrentLocation(context) async {
    final hasPermission = await handleLocationPermission(context);
    if (!hasPermission) return;
    //await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, forceAndroidLocationManager: true).then((Position position) {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
//setState(() {
      currentPosition = position;
      print(" \n \n currentPosition; $currentPosition \n \n ");
      currentP = LatLng(position.latitude, position.longitude);
      getAddressFromLatLon();
      //});
    }).catchError((e) {
      showToast("getCurrentLocation: ${e.toString()}");
      //Fluttertoast.showToast(msg: e.toString());
    });
  }

  getAddressFromLatLon() async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(currentPosition.latitude, currentPosition.longitude);

      Placemark place = placeMarks[0];
      currentAddress.value = "${place.locality},${place.postalCode},${place.street},";
    } catch (e) {
      showToast("getAddressFromLatLon: ${e.toString()}", error: true);
      //Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<bool> handleLocationPermission(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showToast("Location services are disabled. Please enable the services", error: true);
      //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showToast("Location permissions are denied", error: true);
        //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showToast("Location permissions are permanently denied, we cannot request permissions.", error: true);
      //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    showToast("Location services are enabled");
    return true;
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyC_WdqkLQKoxjnUSUVgErrLoecARk430Z4",
      PointLatLng(currentP.latitude, currentP.longitude),
      PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
      travelMode: TravelMode.walking,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  // GOOGLE_MAPS_API_KEY = "AIzaSyC_WdqkLQKoxjnUSUVgErrLoecARk430Z4"

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(polylineId: id, color: Colors.black, points: polylineCoordinates, width: 8);
    polylines[id] = polyline;
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../components/Dragabble FAB.dart';
import '../../../models/location_model.dart';
import '../../../repository/location_repo/LocationRepo.dart';
import '../../../view_models/map_view_models/MapViewModel.dart';

class MapPage extends StatefulWidget {
  final String securityCode;
  const MapPage({super.key, required this.securityCode});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // static const LatLng _pApplePark = LatLng(23.45, 91.17);
  // CameraPosition kGoogle = const CameraPosition(target: LatLng(22.366577, 91.831600), zoom: 14.4746);
  MapViewModel locationVM = Get.put(MapViewModel());

  @override
  void initState() {
    super.initState();
    print(" \n \n \n _listenLocation Error: \n ${locationVM.currentP} \n \n \n ");

    locationVM.handleLocationPermission(context);
    locationVM.getCurrentLocation(context);

    print(" \n \n \n _listenLocation: \n ${locationVM.currentP} \n \n \n ");

    locationVM.markers.add(Marker(
        markerId: const MarkerId("Current Location"),
        icon: BitmapDescriptor.defaultMarker,
        position: locationVM.currentP,
        infoWindow: const InfoWindow(title: 'My Position')));
    // locationVM.markers
    //     .add(Marker(markerId: const MarkerId("userLocation"), icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan), position: _pGooglePlex));

    //locationVM.markers.add(const Marker(markerId: MarkerId('1'), position: LatLng(20.42796133580664, 75.885749655962), infoWindow: InfoWindow(title: 'My Position')));
    // getLocationUpdates().then((_) => {
    //       getPolylinePoints().then((coordinates) => {generatePolyLineFromPoints(coordinates), print(coordinates)})
    //     });
  }

  // Future<void> _cameraToPosition(LatLng pos) async {
  //   final GoogleMapController controller = await _mapController.future;
  //   CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 15);
  //   await controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  // }

  LocationRepo locationRepo = LocationRepo();
  Completer<GoogleMapController> mapController = Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(backgroundColor: const Color(0xFF0F9D58), title: const Text("GFG")),
      body: SafeArea(
          child: FutureBuilder(
              future: locationRepo.getUserLocationApi(widget.securityCode, context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                //showToast("${widget.securityCode}");
                UserLocation location = UserLocation.fromJson(jsonDecode(snapshot.data));

                final element = snapshot.data;
                if (element != null) {
                  // marker added for target users location
                  locationVM.markers.add(Marker(
                    markerId: const MarkerId("1"),
                    position: LatLng(location.latitude, location.longitude),
                    infoWindow: const InfoWindow(title: 'Target user Location'),
                  ));

                  return Obx(() => GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(location.latitude, location.longitude),
                          zoom: 14,
                        ),
                        markers: Set<Marker>.of(locationVM.markers),
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        compassEnabled: true,
                        // on below line specifying controller on map complete.
                        onMapCreated: (GoogleMapController controller) {
                          mapController.complete(controller);
                        },
                      ));
                  return GetBuilder<MapViewModel>(builder: (controller) {
                    return GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(location.latitude, location.longitude),
                        zoom: 14,
                      ),
                      markers: Set<Marker>.of(controller.markers),
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      compassEnabled: true,
                      // on below line specifying controller on map complete.
                      onMapCreated: (GoogleMapController controller) {
                        mapController.complete(controller);
                      },
                    );
                  });
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })),
      floatingActionButton: DraggableFab(
        icon: Icons.center_focus_strong,
        onPressed: () async => await locationVM.returnToCurrLoc(mapController),
      ),
    );

    // return Scaffold(
    //     body: _currentP == null
    //         ? const Center(child: Text("Loading..."))
    //         : StreamBuilder(
    //             stream: FirebaseFirestore.instance.collection('User').doc(widget.securityCode).collection('location').doc('lat-long').snapshots(),
    //             builder: (context, snapshot) {
    //               if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
    //
    //               //showToast("${widget.securityCode}");
    //
    //               Set<Marker> markers = {};
    //
    //               final element = snapshot.data!.data();
    //
    //               if (element != null) {
    //                 //.doc(widget.securityCode).collection('location').doc('at-long')
    //                 _pGooglePlex = LatLng(element['latitude'], element['longitude']);
    //                 /*markers.add(Marker(
    //                     markerId: MarkerId('sdadd'),
    //                     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
    //                     position: LatLng(element['latitude'], element['longitude'])));*/
    //
    //                 //markers.add(Marker(markerId: MarkerId("_currentLocation"), icon: , position: _currentP!));
    //
    //                 markers.add(Marker(markerId: const MarkerId("_currentLocation"), icon: BitmapDescriptor.defaultMarker, position: _currentP!));
    //                 markers
    //                     .add(Marker(markerId: const MarkerId("userLocation"), icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan), position: _pGooglePlex));
    //                 return GoogleMap(
    //                   onMapCreated: ((GoogleMapController controller) => _mapController.complete(controller)),
    //                   initialCameraPosition: CameraPosition(target: _pGooglePlex, zoom: 12),
    //                   /*markers: {
    //                   Marker(
    //                       markerId: MarkerId('id'),
    //                       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
    //                       position: LatLng(
    //                         snapshot.data!.docs.singleWhere((element) => element.id == widget.user_id)['latitude'],
    //                         snapshot.data!.docs.singleWhere((element) => element.id == widget.user_id)['longitude'],
    //                       )),
    //                   //Marker(markerId: MarkerId("_sourceLocation"), icon: BitmapDescriptor.defaultMarker, position: _pGooglePlex),
    //                   //Marker(markerId: MarkerId("_destionationLocation"), icon: BitmapDescriptor.defaultMarker, position: _pApplePark)
    //                 },*/
    //                   markers: markers,
    //                   polylines: Set<Polyline>.of(polylines.values),
    //                 );
    //               } else {
    //                 return const Center(child: CircularProgressIndicator());
    //               }
    //             },
    //           ));
  }

  // Future<void> getLocationUpdates() async {
  //   bool serviceEnabled;
  //   PermissionStatus permissionGranted;
  //
  //   serviceEnabled = await _locationController.serviceEnabled();
  //   if (serviceEnabled) {
  //     serviceEnabled = await _locationController.requestService();
  //   } else {
  //     return;
  //   }
  //
  //   permissionGranted = await _locationController.hasPermission();
  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await _locationController.requestPermission();
  //     if (permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  //
  //   _locationController.onLocationChanged.listen((LocationData currentLocation) {
  //     if (currentLocation.latitude != null && currentLocation.longitude != null) {
  //       setState(() {
  //         _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
  //         _cameraToPosition(_currentP!);
  //       });
  //     }
  //   });
  // }
}

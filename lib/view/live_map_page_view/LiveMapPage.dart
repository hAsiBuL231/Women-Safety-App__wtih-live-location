import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shake/shake.dart';
import 'package:get/get.dart';

import '../../.resources/colours/app_colours.dart';
import '../../.utils/Functions.dart';
import '../../components/drawer.dart';
import '../../view_models/home_page_model/HomePageModel.dart';
import '../../view_models/home_page_model/sms_model/Sms_Model.dart';
import '../../view_models/map_view_models/MapViewModel.dart';
import 'widgets/group_list_widget.dart';
import 'widgets/radio_button_widget.dart';
import 'widgets/security_code_widget.dart';

class LiveMapPage extends StatefulWidget {
  const LiveMapPage({super.key});

  @override
  State<LiveMapPage> createState() => _LiveMapPageState();
}

//class _HomePageWidgetState extends State<HomePageWidget> with TickerProviderStateMixin {

class _LiveMapPageState extends State<LiveMapPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final smsVm = Get.put(SmsModel());
  final locationVM = Get.put(MapViewModel());

  @override
  void initState() {
    super.initState();

    final homePageVM = Get.put(HomePageModel());
    homePageVM.loadData(context);
    homePageVM.getLiveLocPer();
    //WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    //final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    //final smsProvider = Provider.of<SmsProvider>(context, listen: false);

    //shared_Preferences().saveName('Hasibul Hossain');
    //shared_Preferences().loadName().then((value) => name = value);
    ShakeDetector.autoStart(
      onPhoneShake: () async {
        showToast("Shake! Shake!");
        Get.snackbar("Shake", "Shake");

        await Geolocator.requestPermission();
        await Permission.sms.request();

        smsVm.getAndSendSMS();
        //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shake!')));
        // Do stuff on phone shake
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //shared_Preferences().loadName().then((value) => name = value);
    //var userDataProvider = Provider.of<UserDataProvider>(context);

    return SafeArea(
      child: Scaffold(
        drawer: const DrawerWidget(),
        key: scaffoldKey,
        backgroundColor: AppColours.primaryBackground,
        body: Padding(
          padding: const EdgeInsets.all(6),
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
                const SizedBox(height: 30),

                /// /////////////////////////// Enable Live Location   ///////////////////////////

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: radioButton(context),
                ),
                const SizedBox(height: 0),

                /// ///////////////////////////    Your security code   ///////////////////////////

                securityCodeView,

                /// ///////////////////////////    Create new Group   ///////////////////////////

                groupListWidget(context),
                const SizedBox(height: 20),

                /// ///////////////////////////    Next Button   ///////////////////////////

                // ElevatedButton(onPressed: () => nextPage(MapScreen(), context), child: const Text("Next Page")),
                // const SizedBox(height: 20),

                // /// ///////////////////////////    User Data   ///////////////////////////
                //
                // Selector<UserDataProvider, Users?>(
                //     selector: (_, provider) => provider.userData,
                //     builder: (_, userData, __) {
                //       return Text('Stored Data: ${userData!.name}');
                //     }),
                //
                // /// ///////////////////////////    End   ///////////////////////////
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

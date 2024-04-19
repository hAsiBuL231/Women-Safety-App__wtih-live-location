import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/.data/user_data_SharedPreferences/app_user_data.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../.utils/Functions.dart';
import '../view_models/home_page_model/HomePageModel.dart';
import 'Authentication/login_view/LoginPageView.dart';
import 'bottom_screens/BottomPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progressValue = 0.0;
  Timer? _timer;
  Prefs prefs = Prefs();

  @override
  initState() {
    super.initState();

    try {
      // var userName = prefs.get(prefs.username) ?? '';
      // var token = prefs.get(prefs.token) ?? '';
      //
      // if (token != '') {
      final homePageVM = Get.put(HomePageModel());
      homePageVM.loadData(context).then((value) {
        _startTimer();
      });
      //}
    } catch (e) {
      showToast("Failed to get preferences: $e", error: true);
    }
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _startTimer() async {
    const oneSec = Duration(seconds: 1);

    var userName = await prefs.get(prefs.username) ?? '';
    var token = await prefs.get(prefs.token) ?? '';

    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (_progressValue == 1.0) {
            timer.cancel();
            _timer?.cancel();

            if (token != '') {
              showToast('Welcome Back, $userName!');
              newPage(const BottomPage(), context);
            } else {
              newPage(const LoginPageView(), context);
            }

            // User? user = FirebaseAuth.instance.currentUser;
            // if (user == null) {
            //   print('User is currently signed out!');
            //   newPage(const LoginPageView(), context);
            //   //Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPageView()));
            // } else {
            //   print('User is logged in!');
            //   if (user.displayName != null || user.displayName != '') {
            //     showToast('Welcome Back, ${user.displayName}!');
            //     newPage( const BottomPage(), context);
            //     //Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePageWidget()));
            //   } else {
            //     nextPage(const UserForm(), context);
            //   }
            // }
          } else {
            _progressValue += 0.2;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.asset("Assets/images/maps.jpg").image,
                /*image: Image.network(
                  'https://images.unsplash.com/photo-1604357209793-fca5dca89f97?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxtYXB8ZW58MHx8fHwxNzA3OTA5NjQyfDA&ixlib=rb-4.0.3&q=80&w=1080',
                ).image,*/
                opacity: 1,
                fit: BoxFit.cover)),
        child: Stack(children: [
          Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.8),
              Text("Loading Data...", style: TextStyle(color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic, fontFamily: GoogleFonts.aboreto.toString())),
              //const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 4),
              SizedBox(width: MediaQuery.of(context).size.width * 0.7, child: const LinearProgressIndicator(color: Colors.white, minHeight: 5))
            ]),
          )
          /*Image.network(
            'https://images.unsplash.com/photo-1604357209793-fca5dca89f97?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxtYXB8ZW58MHx8fHwxNzA3OTA5NjQyfDA&ixlib=rb-4.0.3&q=80&w=1080',
          )*/
        ]),
      ),
    );
  }
}

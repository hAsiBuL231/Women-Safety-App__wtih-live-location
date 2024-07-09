import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../.utils/Functions.dart';
import '../../repository/login_repository/LoginRepository.dart';

import '../../view/splash_screen.dart';

class LoginViewModel extends GetxController {
  final _api = LoginRepository();

  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  final emailFocusNode = FocusNode().obs;
  final passwordFocusNode = FocusNode().obs;

  RxBool passwordVisibility = false.obs;

  RxBool loading = false.obs;

  Future<void> loginApi(context) async {
    // loading.value = true;
    Map data = {
      "username": emailController.value.text,
      "password": passwordController.value.text,
    };
    /*{
      "username": "Hasibul",
      "password": "123456"
    }*/

/*
    {
    "email": "hossainhasibul2@gmail.com",
    "name": "Md Hasibul Hossain",
    "phone": 140140,
    "imageUrl": "https://upload.wikimedia.org/wikipedia/en/0/0b/Darth_Vader_in_The_Empire_Strikes_Back.jpg",
    "latitude": 12.25,
    "longitude": 98.95,
    "token": "bd4f4fbe433aa17ec3b4ecd0e2463f53147e0f0a"
    }
*/

    try {
      LoginRepository repo = LoginRepository();
      var response = await repo.loginApi(data, context);
      snackBar('Login successful', context);

      Get.delete<LoginViewModel>();

      await Future.delayed(const Duration(seconds: 10));
      nextPage(const SplashScreen(), context);
      // nextPage(const BottomPage(), context);
    } catch (e) {
      showToast("sf: ${e.toString()}", error: true);
    }

    loading.value = false;
  }

  // googleLoginApi(context) async {
  //   try {
  //     final googleUser = await GoogleSignIn().signIn();
  //     if (googleUser == null) return;
  //     final googleAuth = await googleUser.authentication;
  //     final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //   } catch (e) {
  //     showToast(e.toString());
  //   }
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     print('User is Signed in!');
  //     //Get.to(const HomePageWidget());
  //     nextPage(const SplashScreen(), context);
  //   }
  // }
}

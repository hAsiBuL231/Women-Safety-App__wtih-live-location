//SignUpViewModel

import 'package:flutter/cupertino.dart';
import 'package:flutter_women_safety_app/view/splash_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../.data/user_data_SharedPreferences/app_user_data.dart';
import '../../.utils/Functions.dart';
import '../../repository/location_repo/LocationRepo.dart';
import '../../repository/login_repository/LoginRepository.dart';
import '../../repository/sos_history_repo/SOSHistoryRepo.dart';
import '../../view/bottom_screens/BottomPage.dart';
import '../user_view_model/UserViewModel.dart';

class SignUpViewModel extends GetxController {
  final _api = LoginRepository();

  final usernameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final confirmPasswordController = TextEditingController().obs;

  final usernameFocusNode = FocusNode().obs;
  final emailFocusNode = FocusNode().obs;
  final phoneFocusNode = FocusNode().obs;
  final passwordFocusNode = FocusNode().obs;
  final confirmPasswordFocusNode = FocusNode().obs;

  RxBool passwordVisibility1 = false.obs;
  RxBool passwordVisibility2 = false.obs;

  RxBool loading = false.obs;

  Future<void> signUpApi(context) async {
    loading.value = true;
    Map data = {
      'username': usernameController.value.text,
      'email': emailController.value.text,
      'password': passwordController.value.text,
    };

    try {
      LoginRepository repo = LoginRepository();
      var response = await repo.registerApi(data, context);

      Prefs prefs = Prefs();
      var userName = await prefs.get(prefs.username) ?? '';
      var token = await prefs.get(prefs.token) ?? '';

      if (token != '') {
        snackBar('Signup successful', context);

        prefs.setInt(prefs.user_number, int.parse(phoneController.value.text));

        UserViewModel repo2 = UserViewModel();
        var response2 = await repo2.postUserApi(context);

        await Geolocator.requestPermission();
        LocationRepo repo3 = LocationRepo();
        var response3 = await repo3.postUserLocationApi(context);

        SOSHistoryRepo repo4 = SOSHistoryRepo();
        var response4 = await repo4.postUserSOSHistoryApi();

        Get.delete<SignUpViewModel>();
        nextPage(const SplashScreen(), context);
        //nextPage(const BottomPage(), context);
      }
    } catch (e) {
      showToast(e.toString(), error: true);
    }

    loading.value = false;

    // _api.loginApi(data).then((value) {
    //   loading.value = false;
    //   Utils.snackBar('Login', 'Login successful');
    //   Get.to(const BottomPage());
    // }).onError((error, stackTrace) {
    //   loading.value = false;
    //   Utils.snackBar('Error', error.toString());
    // });
  }
}

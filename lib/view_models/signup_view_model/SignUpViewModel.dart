//SignUpViewModel

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../.utils/Functions.dart';
import '../../.utils/utils.dart';
import '../../repository/login_repository/LoginRepository.dart';
import '../../view/bottom_screens/BottomPage.dart';
import '../user_view_model/UserViewModel.dart';

class SignUpViewModel extends GetxController {
  final _api = LoginRepository();

  final usernameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final confirmPasswordController = TextEditingController().obs;

  final usernameFocusNode = FocusNode().obs;
  final emailFocusNode = FocusNode().obs;
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
      var response = repo.registerApi(data, context);
      snackBar('Login successful', context);

      UserViewModel().postUserApi(context);

      Get.delete<SignUpViewModel>();
      nextPage(const BottomPage(), context);
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

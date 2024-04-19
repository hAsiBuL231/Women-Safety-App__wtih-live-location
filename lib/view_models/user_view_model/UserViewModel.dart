import 'package:flutter_women_safety_app/repository/user_repository/UserRepository.dart';
import 'package:get/get.dart';
import '../../.data/user_data_SharedPreferences/app_user_data.dart';
import '../../.utils/Functions.dart';
import 'package:http/http.dart' as http;

class UserViewModel extends GetxController {
  final _api = UserRepository();

  // final nameController = TextEditingController().obs;
  // final phoneController = TextEditingController().obs;
  // final emailController = TextEditingController().obs;

  RxString imageUrl = "".obs;

  RxBool loading = false.obs;

  Future<dynamic> getUserApi(context) async {
    var response;
    try {
      response = await _api.getUserApi();
      snackBar('Get User data successful', context);
      // showToast(response, error: false);
    } catch (e) {
      showToast("sf: ${e.toString()}", error: true);
    }
    return response;
  }

  Future<void> postUserApi(context) async {
    Prefs prefs = Prefs();
    String token = await prefs.get(prefs.token);
    String email = await prefs.get(prefs.email);

    // loading.value = true;
    Map data = {
      "token": token,
      "email": email,
      "name": "Please enter your name",
      "phone": 018,
      // "email": emailController.value.text,
      // "name": nameController.value.text,
      // "phone": phoneController.value.text,
      "imageUrl": "https://upload.wikimedia.org/wikipedia/en/0/0b/Darth_Vader_in_The_Empire_Strikes_Back.jpg",
      "latitude": 0,
      "longitude": 0
    };

    try {
      var response = await _api.postUserApi(data);
      snackBar('User Created', context);

      // Get.delete<UserViewModel>();
      // nextPage(const BottomPage(), context);
      // showToast(response, error: false);
    } catch (e) {
      showToast("postUserApi: ${e.toString()}", error: true);
    }

    loading.value = false;
  }

  /*
    {
      "username": "Hasibul",
      "password": "123456"
    }
*/
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

  Future<void> patchUserPhoneApi(int phone) async {
    Prefs prefs = Prefs();
    String token = await prefs.get(prefs.token);

    Map data = {"phone": "$phone"};

    try {
      var response = await _api.patchUserApi(data);
      // snackBar('User data update successful', context);
    } catch (e) {
      showToast("patchUserPhoneApi: ${e.toString()}", error: true);
    }
  }

  Future<void> patchUserNameApi(String name) async {
    Map data = {"name": name};

    try {
      var response = await _api.patchUserApi(data);
    } catch (e) {
      showToast("patchUserNameApi: ${e.toString()}", error: true);
    }
  }

/*
    {
      "username": "Hasibul",
      "password": "123456"
    }
*/
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
}

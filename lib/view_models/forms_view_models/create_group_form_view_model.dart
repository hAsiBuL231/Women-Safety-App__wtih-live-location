import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/.data/network/network_api_services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../.data/user_data_SharedPreferences/app_user_data.dart';
import '../../.resources/app_url/AppUrl.dart';
import '../../.utils/Functions.dart';

class CreateGroupFormViewModel extends GetxController {
  Rx<TextEditingController> groupNameController = TextEditingController().obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxString imageUrl = "".obs;

  Future<void> submitForm(context) async {
    if (formKey.currentState!.validate()) {
      try {
        final provider = Provider.of<UserDataProvider>(context, listen: false);

        String securityCode = provider.userData!.securityCode;

        //var user = provider.userData!.toJson();

        //user['securityCode'] = "http://192.168.0.106:8000/users/$securityCode/";

        //user['url'] = user['securityCode'];
        //user.remove('securityCode');

        Map data = {
          "name": groupNameController.value.text,
          "imageUrl": "imageUrl",
          "users": ["${AppUrl.usersUrl}$securityCode/"]
          //"users": [provider.userData],
        };

        final apiServices = NetworkApiServices();

        String jsonData = json.encode(data);

        var res = apiServices.postApi(jsonData, AppUrl.groupsUrl).then((value) => const SnackBar(content: Text('Data added')));

        // CollectionReference users = FirebaseFirestore.instance.collection('User');
        // // Add the user data to Firestore
        // await users
        //     .doc(provider.userData!.securityCode)
        //     .collection('group')
        //     .doc()
        //     .set({'name': groupNameController.value.text, 'image': imageUrl.value, 'id_list': []})
        //     .then((value) => const SnackBar(content: Text('Data added')))
        //     .catchError((error) => SnackBar(content: Text('Error: $error')));

        // Clear the form fields
        groupNameController.value.clear();
        Navigator.pop(context);
      } catch (e) {
        showToast(e.toString(), error: true);
      }

      // showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(title: const Text('Success'), content: const Text('Personal information saved successfully!'), actions: [
      //           TextButton(
      //               onPressed: () {
      //                 groupNameController.value.clear();
      //                 imageUrl.value = '';
      //                 nextPage(const BottomPage(), context);
      //               },
      //               child: const Text('OK'))
      //         ]));
    }
  }

  Future<void> selectPhoto() async {
    //List<Media>? pickedFile = await ImagesPicker.pick(count: 1, pickType: PickType.image);
    //var image = pickedFile?.first;

    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    var image = pickedFile;
    //final pickedFile =
    //    await ImagePicker().pickImage(source: ImageSource.gallery);
    //XFile image = await ImagePickerAndroid.pickImage(source: Images);

    if (pickedFile != null) {
      try {
        // final Reference storageReference = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');
        // final UploadTask uploadTask = storageReference.putFile(File(pickedFile.path));
        // await uploadTask.whenComplete(() => showToast('Photo uploaded. Wait to load the image.'));
        // String url = await storageReference.getDownloadURL();
        // imageUrl.value = url;
        // print(url);

        //Reference ref = FirebaseStorage.instance.ref().child('profile.jpg');
        //await ref.putString(image!.path);
        //ref.getDownloadURL().then((value) {
        //  print(value);
        //  imageUrl.value = value;
        //});
      } catch (e) {
        showToast(e.toString(), error: true);
      }
    }
  }
}

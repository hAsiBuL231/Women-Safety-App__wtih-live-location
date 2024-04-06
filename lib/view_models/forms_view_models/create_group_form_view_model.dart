import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../.data/user_data_SharedPreferences/app_user_data.dart';
import '../../.utils/Functions.dart';
import '../../view/bottom_screens/BottomPage.dart';

class CreateGroupFormViewModel extends GetxController {
  Rx<TextEditingController> groupNameController = TextEditingController().obs;

  RxString imageUrl = "".obs;

  Future<void> submitForm(context) async {
    //if (formKey5.currentState!.validate()) {
    // try {
    //   final provider = Provider.of<UserDataProvider>(context, listen: false);
    //
    //   CollectionReference users = FirebaseFirestore.instance.collection('User');
    //   // Add the user data to Firestore
    //   await users
    //       .doc(provider.userData!.securityCode)
    //       .collection('group')
    //       .doc()
    //       .set({'name': groupNameController.value.text, 'image': imageUrl.value, 'id_list': []})
    //       .then((value) => const SnackBar(content: Text('Data added')))
    //       .catchError((error) => SnackBar(content: Text('Error: $error')));
    //
    //   // Clear the form fields
    //   groupNameController.value.clear();
    // } on FirebaseException catch (e) {
    //   showToast(e.toString(), error: true);
    // }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(title: const Text('Success'), content: const Text('Personal information saved successfully!'), actions: [
              TextButton(
                  onPressed: () {
                    groupNameController.value.clear();
                    imageUrl.value = '';
                    nextPage(const BottomPage(), context);
                  },
                  child: const Text('OK'))
            ]));
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

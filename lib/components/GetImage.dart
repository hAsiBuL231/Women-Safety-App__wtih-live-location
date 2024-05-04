import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/view/user_view/UserView.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_women_safety_app/.resources/app_url/AppUrl.dart';
import 'package:http/http.dart' as http;

import '../.utils/Functions.dart';
import '../view/forms/UserForm.dart';
import '../view_models/user_view_model/UserViewModel.dart';

class GetImage extends StatefulWidget {
  const GetImage({super.key});

  @override
  State<GetImage> createState() => _GetImageState();
}

class _GetImageState extends State<GetImage> {
  //final userEmail = FirebaseAuth.instance.currentUser?.email;
  String imageURL = '';

  _selectPhoto(ImageSource) async {
    setState(() {
      imageURL = 'Failed';
    });
    final pickedFile = await ImagePicker().pickImage(source: ImageSource);

    if (pickedFile == null) {
      snackBar('Image Picking Failed', context);
      showToast('Image Picking Failed');
      return;
    }

    final croppedFile = await ImageCropper().cropImage(
        cropStyle: CropStyle.circle,
        sourcePath: pickedFile.path,
        compressQuality: 100,
        uiSettings: [WebUiSettings(context: context), IOSUiSettings(), AndroidUiSettings()]);

    if (croppedFile == null) {
      snackBar('Image Cropping Failed', context);
      showToast('Image Picking Failed');
      return;
    }
    XFile image = XFile(croppedFile.path);
    _uploadImage(image);

    // try {
    //   final Reference storageReference = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');
    //   final UploadTask uploadTask = storageReference.putFile(File(croppedFile.path));
    //   await uploadTask.whenComplete(() => snackBar('Photo uploaded. Wait to load the image.', context));
    //   String url = await storageReference.getDownloadURL();
    //   setState(() {
    //     imageURL = url;
    //   });
    //   FirebaseAuth.instance.currentUser?.updatePhotoURL(url);
    // } catch (e) {
    //   showToast(e.toString());
    // }

    // FirebaseFirestore.instance.collection('user_list').doc(userEmail).update({
    //   'imageUrl': imageURL,
    // }).then((value) {
    //   const SnackBar(content: Text('Image added'));
    //   FirebaseAuth.instance.currentUser?.updatePhotoURL(imageURL);
    // }).onError((error, stackTrace) {
    //   SnackBar(content: Text('Error: $error'));
    // });
  }

  Future<void> _uploadImage(XFile _image) async {
    var request = http.MultipartRequest('POST', Uri.parse('${AppUrl.baseUrl}/image/upload/'));
    request.files.add(await http.MultipartFile.fromPath('image', _image.path));
    var response = await request.send();
    if (response.statusCode == 200) {
      // Image uploaded successfully
      print('Image uploaded successfully');
      // You can get the image path from the response
      String imagePath = await response.stream.bytesToString();
      var image = jsonDecode(imagePath);
      setState(() {
        imageURL = "${AppUrl.baseUrl}/image/get/${image['image_path']}/";
      });
      print('Image Path: $imagePath');
    } else {
      // Image uploading failed
      print('Image uploading failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(children: [
                      if (imageURL == '')
                        Column(children: [
                          const CircleAvatar(radius: 100, backgroundImage: AssetImage('Assets/images/Profile.png')),
                          const SizedBox(height: 30),
                          TextButton(onPressed: () => showImagePicker(context), child: const Text('Select Image'))
                        ])
                      else if (imageURL == 'Failed')
                        Column(children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 30),
                          TextButton(onPressed: () => showImagePicker(context), child: const Text('Select Again!'))
                        ])
                      else
                        Column(children: [
                          Container(
                              decoration: const ShapeDecoration(shape: CircleBorder(side: BorderSide(color: Colors.blue, width: 10))),
                              child: CircleAvatar(radius: 130, backgroundImage: NetworkImage(imageURL))),
                          const SizedBox(height: 30),
                          FilledButton(
                              onPressed: () async {
                                await UserViewModel().patchUserImageApi(imageURL);
                                nextPage(const UserView(), context);
                              },
                              child: const Text('OK', style: TextStyle(fontSize: 20))),
                          const SizedBox(height: 30),
                          TextButton(onPressed: () => showImagePicker(context), child: const Text('Select Again!'))
                        ])
                    ])))));
  }

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 5,
                  margin: const EdgeInsets.only(top: 8.0),
                  padding: const EdgeInsets.all(12),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Expanded(
                        child: InkWell(
                            child: const Column(children: [
                              Icon(Icons.image, size: 60),
                              SizedBox(height: 12.0),
                              Text("Gallery", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black))
                            ]),
                            onTap: () {
                              _selectPhoto(ImageSource.gallery);
                              Navigator.pop(context);
                            })),
                    Expanded(
                        child: InkWell(
                            child: const SizedBox(
                                child: Column(children: [
                              Icon(Icons.camera_alt, size: 60),
                              SizedBox(height: 12.0),
                              Text("Camera", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black))
                            ])),
                            onTap: () {
                              _selectPhoto(ImageSource.camera);
                              Navigator.pop(context);
                            }))
                  ])));
        });
  }
}

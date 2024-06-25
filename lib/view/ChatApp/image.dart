import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/.resources/app_url/AppUrl.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  String? imageUrl;

  Future<void> _uploadImage() async {
    var request = http.MultipartRequest('POST', Uri.parse('${AppUrl.baseUrl}/image/upload/'));
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    var response = await request.send();
    if (response.statusCode == 200) {
      // Image uploaded successfully
      print('Image uploaded successfully');
      // You can get the image path from the response
      String imagePath = await response.stream.bytesToString();
      imageUrl = jsonDecode(imagePath);
      setState(() {});
      print('Image Path: $imagePath');
    } else {
      // Image uploading failed
      print('Image uploading failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Upload')),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Image.network("${AppUrl.baseUrl}/image/get/$imageUrl/"),
          _image == null ? const Text('No image selected.') : Image.file(_image!),
          ElevatedButton(
            onPressed: () async {
              // Open image picker
              final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
              // Assign the picked image to _image
              _image = File(pickedFile!.path);
              setState(() {});
              // After that, call _uploadImage() method
            },
            child: const Text('Pick Image'),
          ),
          ElevatedButton(
            onPressed: () {
              _uploadImage();
            },
            child: const Text('Upload Image'),
          ),
        ]),
      ),
    );
  }
}

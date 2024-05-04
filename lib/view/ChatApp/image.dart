import 'dart:io';
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

  Future<void> _uploadImage() async {
    var request = http.MultipartRequest('POST', Uri.parse('${AppUrl.baseUrl}/image/upload/'));
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    var response = await request.send();
    if (response.statusCode == 200) {
      // Image uploaded successfully
      print('Image uploaded successfully');
      // You can get the image path from the response
      String imagePath = await response.stream.bytesToString();
      print('Image Path: $imagePath');
    } else {
      // Image uploading failed
      print('Image uploading failed');
    }
  }

  Future<String> fetchImage() async {
    var response = await http.get(Uri.parse("${AppUrl.baseUrl}/image/get/" "IMG-20240503-WA0000.jpg/"));
    String data = response.body;
    return data;
    // return http.get(Uri.parse("${AppUrl.baseUrl}/media/IMG-20240503-WA0000.jpg"));

    // "D:/TrackLive Backend Django/djangorest/media/images/1714494560872.jpg"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Upload')),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Image.network("${AppUrl.baseUrl}/image/get/IMG-20240503-WA0000.jpg/"),

          // FutureBuilder(
          //   future: fetchImage(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const CircularProgressIndicator();
          //     } else if (snapshot.hasError) {
          //       return Text('Error: ${snapshot.error}');
          //     } else {
          //       print(" \n \n Response: ${snapshot.data!} \n \n ");
          //       return Column(children: [
          //         //Image.network(snapshot.data!.bodyBytes.toString()),
          //         Image.network("${AppUrl.baseUrl}/image/get/IMG-20240503-WA0000.jpg/"),
          //       ]);
          //     }
          //   },
          // ),
          // Image.network("C:/Users/MD_Hasibul/Desktop/AppServerImage/IMG-20240503-WA0000.jpg"),
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

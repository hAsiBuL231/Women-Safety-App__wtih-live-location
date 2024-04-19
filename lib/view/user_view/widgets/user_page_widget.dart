import 'dart:async';

import 'package:flutter/material.dart';

import '../../../models/user_model.dart';

// Widget builds the display item with the proper formatting to display the user's info
Widget buildUserInfoDisplay(String getValue, String title, Widget editPage, context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey)),
      const SizedBox(height: 1),
      Container(
          width: 350,
          height: 40,
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
          child: Row(children: [
            Expanded(child: TextButton(onPressed: () => navigateSecondPage(editPage, context), child: Text(getValue, style: const TextStyle(fontSize: 16, height: 1.4)))),
            const Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 40.0)
          ]))
    ]));

// Widget builds the About Me Section
Widget buildAbout(Users user) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        'Tell Us About Yourself',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
      ),
      const SizedBox(height: 1),
      Container(
          width: 350,
          // height: 200,
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
          child: Row(children: [
            Expanded(
                child: TextButton(
                    onPressed: () {
                      // navigateSecondPage(EditDescriptionFormPage());
                    },
                    child: const Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'jnj',
                              // user.aboutMeDescription,
                              style: TextStyle(fontSize: 16, height: 1.4),
                            ))))),
            const Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 40.0)
          ]))
    ]));

// Refrshes the Page after updating user info.
FutureOr onGoBack(dynamic value) {
   // setState(() {});
}

// Handles navigation and prompts refresh.
void navigateSecondPage(Widget editForm, context) {
  Route route = MaterialPageRoute(builder: (context) => editForm);
  Navigator.push(context, route).then(onGoBack);
}

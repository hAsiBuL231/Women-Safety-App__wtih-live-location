import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/.utils/Functions.dart';
import 'package:flutter_women_safety_app/components/customText.dart';
import 'package:flutter_women_safety_app/view/Authentication/login_view/LoginPageView.dart';
import 'package:flutter_women_safety_app/view_models/user_view_model/UserViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/GetImage.dart';
import '../../components/buttons/SecondaryButton.dart';
import '../../models/user_model.dart';
import '../ChatApp/image.dart';
import 'Admin View Pages/SOSHistoryPage.dart';
import 'widgets/display_image_widget.dart';

import 'pages/edit_email.dart';
import 'pages/edit_image.dart';
import 'pages/edit_name.dart';
import 'pages/edit_phone.dart';
import 'widgets/user_page_widget.dart';

// This class handles the Page to dispaly the user's info on the "Edit Profile" Screen
class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  // late Users user;
  // Prefs prefs = Prefs();

  // getUser() async {
  //   var json = await prefs.get('user') ?? '';
  //   // SharedPreferences preferences = await SharedPreferences.getInstance();
  //   // var json = preferences.getString('user');
  //   user = Users.fromJson(jsonDecode(json));
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUser();
  }

  void refreshScreen() {
    // Implement your refresh logic here
    setState(() {
      // Update state or reload data
    });
  }

  @override
  Widget build(BuildContext context) {
    // final user = UserData.myUser;
    // final user = UserData.getUser();
    // final SharedPreferences prefs = SharedPreferences.getInstance() as SharedPreferences;
    // final String? value = prefs.getString('user');
    UserViewModel mod = UserViewModel();

    // UserData.init();
    return FutureBuilder(
        // future: UserData.getUser(),
        future: mod.getUserApi(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.data != null) {
            Users user = Users.fromJson(jsonDecode(snapshot.data));

            return Scaffold(
              body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(children: [
                    AppBar(backgroundColor: Colors.transparent, elevation: 0, toolbarHeight: 10),
                    const Center(
                        child: Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Color.fromRGBO(64, 105, 225, 1)),
                            ))),
                    InkWell(
                        onTap: () => navigateSecondPage(const GetImage(), context),
                        child: DisplayImage(
                          imagePath: user.imageUrl,
                          onPressed: () {},
                        )),
                    buildUserInfoDisplay(user.name, 'Name', EditNameFormPage(refreshCallback: refreshScreen), context),
                    buildUserInfoDisplay("0${user.phone}", 'Phone', EditPhoneFormPage(refreshCallback: refreshScreen), context),
                    buildUserInfoDisplay(user.email, 'Email', const EditEmailFormPage(), context),
                    // Expanded(flex: 4, child: buildAbout(user)),
                    const SizedBox(height: 100),
                    SecondaryButton(
                        title: "Logout",
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.clear();
                          newPage(const LoginPageView(), context);
                        }),

                    /// //////////////////////////////  Admin Section ////////////////////////////
                    if (user.email == "hossainhasibul2@gmail.com") ...[
                      const SizedBox(height: 40),
                      customText(text: "Admin Section:", fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      const SizedBox(height: 6),
                      SecondaryButton(title: "See SOS History", onPressed: () => nextPage(const SOSHistoryPage(), context)),
                    ]
                  ])),
            );
          }
          // return const Center(child: CircularProgressIndicator());
          return Center(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("${snapshot.error}"),
              const SizedBox(height: 60),
              SecondaryButton(
                  title: "Logout",
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    newPage(const LoginPageView(), context);
                  })
            ]),
          );
        });
  }
}

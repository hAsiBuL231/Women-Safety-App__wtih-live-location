import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../.utils/Functions.dart';
import '../../../.utils/utils.dart';
import '../../../view_models/signup_view_model/SignUpViewModel.dart';
import '../../../view_models/login_view_model/LoginViewModel.dart';
import '../forget_password_view/ForgetPasswordPage.dart';
import '../signup_view/SignUpPageView.dart';
import 'package:http/http.dart' as http;

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  State<LoginPageView> createState() => LoginPageViewState();
}

class LoginPageViewState extends State<LoginPageView> {
  final loginPageScaffoldKey = GlobalKey<ScaffoldState>();
  final loginVM = Get.put(LoginViewModel());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.asset("Assets/images/maps.jpg").image,
                /*image: Image.network(
                  'https://images.unsplash.com/photo-1604357209793-fca5dca89f97?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxtYXB8ZW58MHx8fHwxNzA3OTA5NjQyfDA&ixlib=rb-4.0.3&q=80&w=1080',
                ).image,*/
                opacity: 0.7,
                fit: BoxFit.cover)),
        child: SafeArea(
            child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 110, bottom: 20, right: 25, left: 25),
            child: Column(children: [
              const Text("Welcome Back!\nLogin", textAlign: TextAlign.center, style: TextStyle(fontSize: 34, color: Colors.white, fontFamily: "Raleway", height: 1.2)),
              TextButton(
                  onPressed: () => nextPage(const SignUpPageView(), context),
                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                  child: const Text("New User? Register", style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'OpenSans'))),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                      controller: loginVM.emailController.value,
                      focusNode: loginVM.emailFocusNode.value,
                      validator: (value) {
                        // if (value!.contains('@gmail.com')) {
                        //   return null;
                        // }
                        // if (value!.isEmail) {
                        //   return null;
                        // }
                        // return 'Please enter a valid Gmail!';
                        if (value == null) {
                          return 'Please enter a valid username';
                        }
                        return null;
                      },
                      //onChanged: (value) => _email = value,
                      onFieldSubmitted: (value) => Utils.fieldFocusChange(context, loginVM.emailFocusNode.value, loginVM.passwordFocusNode.value),
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.mail, color: Colors.white),
                          hintText: 'Username',
                          labelText: 'Username',
                          fillColor: Colors.white70,
                          filled: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)))),
                  const SizedBox(height: 20),
                  Obx(() => TextFormField(
                      controller: loginVM.passwordController.value,
                      focusNode: loginVM.passwordFocusNode.value,
                      validator: (input) {
                        if (input!.length < 4) {
                          return 'Your password needs to be at least 4 character';
                        }
                        return null;
                      },
                      obscureText: !loginVM.passwordVisibility.value,
                      //onChanged: (value) => _password = value,
                      onFieldSubmitted: (value) {
                        if (_formKey.currentState!.validate()) {
                          loginVM.loginApi(context);
                        }
                      },
                      decoration: InputDecoration(
                          hintText: 'Password',
                          labelText: 'Password',
                          fillColor: Colors.white70,
                          filled: true,
                          prefixIcon: const Icon(Icons.vpn_key, color: Colors.white),
                          suffixIcon: InkWell(
                              onTap: () => setState(() => loginVM.passwordVisibility.value = !loginVM.passwordVisibility.value),
                              focusNode: FocusNode(skipTraversal: true),
                              child: Icon(loginVM.passwordVisibility.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: const Color(0x80FFFFFF), size: 22)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))))),
                ]),
              ),
              TextButton(
                  onPressed: () => nextPage(const ForgetPasswordPage(), context),
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                      textStyle: MaterialStatePropertyAll(TextStyle(decoration: TextDecoration.underline))),
                  child: const Text("Forgot Password?", style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'OpenSans'))),
              const SizedBox(height: 40),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                const Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 32, fontFamily: "Raleway")),
                Obx(() {
                  if (loginVM.loading.isFalse) {
                    return FloatingActionButton(
                        child: const Icon(Icons.arrow_forward),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) loginVM.loginApi(context);
                        });
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
              ]),
              const SizedBox(height: 20),
              FloatingActionButton.extended(
                  heroTag: 'googleLogin',
                  onPressed: () async {
                    Map<String, String> headers = {
                      //"Content-Type": "text/plain",
                      "Access-Control-Allow-Origin": "*",
                    };
                    final response = await http.get(Uri.parse('http://192.168.0.111:8000/auth/register'), headers: headers);
                    var responseBody = jsonDecode(response.body);
                    // String responseBody = json.decode(response.body).cast<Map<String, dynamic>>();
                    print(responseBody);
                    // loginVM.googleLoginApi(context);
                  },
                  //icon: Image.asset('images/google_logo.png', height: 28, width: 28),
                  icon: const Icon(Icons.g_mobiledata, size: 60),
                  label: const Text('Sign in with Google'),
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white),
              const SizedBox(height: 20),
            ]),
          ),
        )));
  }
}

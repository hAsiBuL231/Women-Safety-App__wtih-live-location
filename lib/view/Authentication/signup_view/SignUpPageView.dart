import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../.utils/Functions.dart';
import '../../../.utils/utils.dart';
import '../../../view_models/signup_view_model/SignUpViewModel.dart';
import '../login_view/LoginPageView.dart';

class SignUpPageView extends StatefulWidget {
  const SignUpPageView({super.key});

  @override
  State<SignUpPageView> createState() => _SignUpPageViewState();
}

class _SignUpPageViewState extends State<SignUpPageView> {
  final signUpVM = Get.put(SignUpViewModel());
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
              const Text("Welcome!\nRegister Now", textAlign: TextAlign.center, style: TextStyle(fontSize: 34, color: Colors.white, fontFamily: "Raleway", height: 1.2)),
              TextButton(
                  onPressed: () => nextPage(const LoginPageView(), context),
                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                  child: const Text("Have an account? Login", style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'OpenSans'))),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(children: [
                  Obx(() => TextFormField(
                      controller: signUpVM.usernameController.value,
                      focusNode: signUpVM.usernameFocusNode.value,
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter a valid username';
                        }
                        return null;
                      },
                      //onChanged: (value) => _email = value,
                      onFieldSubmitted: (value) => Utils.fieldFocusChange(context, signUpVM.usernameFocusNode.value, signUpVM.emailFocusNode.value),
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.mail, color: Colors.white),
                          hintText: 'User name',
                          labelText: 'User name',
                          fillColor: Colors.white70,
                          filled: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))))),
                  const SizedBox(height: 20),
                  Obx(() => TextFormField(
                      controller: signUpVM.emailController.value,
                      focusNode: signUpVM.emailFocusNode.value,
                      validator: (value) {
                        /*if (value!.contains('@gmail.com')) {
                          return null;
                        }*/
                        if (value!.isEmail) {
                          return null;
                        }
                        return 'Please enter a valid Gmail!';
                      },
                      //onChanged: (value) => _email = value,
                      onFieldSubmitted: (value) => Utils.fieldFocusChange(context, signUpVM.emailFocusNode.value, signUpVM.passwordFocusNode.value),
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.mail, color: Colors.white),
                          hintText: 'Email',
                          labelText: 'Email',
                          fillColor: Colors.white70,
                          filled: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))))),
                  const SizedBox(height: 20),
                  Obx(() => TextFormField(
                      controller: signUpVM.passwordController.value,
                      focusNode: signUpVM.passwordFocusNode.value,
                      validator: (input) {
                        if (input!.length < 6) {
                          return 'Your password needs to be at least 6 character';
                        }
                        return null;
                      },
                      obscureText: !signUpVM.passwordVisibility1.value,
                      //onChanged: (value) => _password = value,
                      onFieldSubmitted: (value) => Utils.fieldFocusChange(context, signUpVM.passwordFocusNode.value, signUpVM.confirmPasswordFocusNode.value),
                      decoration: InputDecoration(
                          hintText: 'Password',
                          labelText: 'Password',
                          fillColor: Colors.white70,
                          filled: true,
                          prefixIcon: const Icon(Icons.vpn_key, color: Colors.white),
                          suffixIcon: InkWell(
                              onTap: () => setState(() => signUpVM.passwordVisibility1.value = !signUpVM.passwordVisibility1.value),
                              focusNode: FocusNode(skipTraversal: true),
                              child: Icon(signUpVM.passwordVisibility1.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: const Color(0x80FFFFFF), size: 22)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))))),
                  const SizedBox(height: 20),
                  Obx(() => TextFormField(
                      controller: signUpVM.confirmPasswordController.value,
                      focusNode: signUpVM.confirmPasswordFocusNode.value,
                      validator: (input) {
                        if (signUpVM.passwordController.value.text != signUpVM.confirmPasswordController.value.text) {
                          return 'Your password needs to be matched previous one!';
                        }
                        return null;
                      },
                      obscureText: !signUpVM.passwordVisibility2.value,
                      //onChanged: (value) => _password = value,
                      onFieldSubmitted: (value) {
                        if (_formKey.currentState!.validate()) {
                          signUpVM.signUpApi(context);
                        }
                      },
                      decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          labelText: 'Confirm Password',
                          fillColor: Colors.white70,
                          filled: true,
                          prefixIcon: const Icon(Icons.vpn_key, color: Colors.white),
                          suffixIcon: InkWell(
                              onTap: () => setState(() => signUpVM.passwordVisibility2.value = !signUpVM.passwordVisibility2.value),
                              focusNode: FocusNode(skipTraversal: true),
                              child: Icon(signUpVM.passwordVisibility2.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: const Color(0x80FFFFFF), size: 22)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))))),
                ]),
              ),
              const SizedBox(height: 40),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                const Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 32, fontFamily: "Raleway")),
                Obx(() {
                  if (signUpVM.loading.isFalse) {
                    return FloatingActionButton(
                        child: const Icon(Icons.arrow_forward),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) signUpVM.signUpApi(context);
                        });
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
              ]),
              const SizedBox(height: 20),
            ]),
          ),
        )));
  }
}

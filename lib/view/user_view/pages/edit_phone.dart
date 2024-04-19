import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/.utils/Functions.dart';
import 'package:flutter_women_safety_app/view/user_view/UserView.dart';
import '../user/user_data.dart';
import '../widgets/appbar_widget.dart';

// This class handles the Page to edit the Phone Section of the User Profile.
class EditPhoneFormPage extends StatefulWidget {
  const EditPhoneFormPage({Key? key}) : super(key: key);
  @override
  EditPhoneFormPageState createState() {
    return EditPhoneFormPageState();
  }
}

class EditPhoneFormPageState extends State<EditPhoneFormPage> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  var user = UserData.myUser;
  //var user = await UserData.getUser();

  getUser() async {
    user = await UserData.getUser();
    phoneController.text = "${user.phone}";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void updateUserValue(String phone) {
    String formattedPhoneNumber = "(" + phone.substring(0, 3) + ") " + phone.substring(3, 6) + "-" + phone.substring(6, phone.length);
    // user.phone = formattedPhoneNumber as int;
    user.phone = int.parse(phone);
    UserData.setUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              const SizedBox(
                  width: 320,
                  child: Text(
                    "What's Your Phone Number?",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SizedBox(
                      height: 100,
                      width: 320,
                      child: TextFormField(
                        // Handles Form Validation
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                            // } else if (isAlpha(value)) {
                            //   return 'Only Numbers Please';
                          } else if (value.length < 10) {
                            return 'Please enter a VALID phone number';
                          }
                          return null;
                        },
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Your Phone Number',
                        ),
                      ))),
              Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 320,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate() /*&& isNumeric(phoneController.text)*/) {
                              updateUserValue(phoneController.text);
                              Navigator.pop(context);
                              nextPage(const UserView(), context);
                            }
                          },
                          child: const Text(
                            'Update',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      )))
            ]),
          ),
        ));
  }
}

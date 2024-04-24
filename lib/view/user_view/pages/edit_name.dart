import 'package:flutter/material.dart';
import '../../../view_models/user_view_model/UserViewModel.dart';
import '../user/user_data.dart';

// This class handles the Page to edit the Name Section of the User Profile.
class EditNameFormPage extends StatefulWidget {
  final VoidCallback refreshCallback;

  const EditNameFormPage({super.key, required this.refreshCallback});

  @override
  EditNameFormPageState createState() {
    return EditNameFormPageState();
  }
}

class EditNameFormPageState extends State<EditNameFormPage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  var user = UserData.myUser;

  getUser() async {
    user = await UserData.getUser();
    firstNameController.text = user.name;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    super.dispose();
  }

  void _updateUserValue(String name) {
    user.name = name;
    UserViewModel().patchUserNameApi(user.name);
    UserData.setUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          leading: const BackButton(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              const SizedBox(
                  width: 330,
                  child: Text(
                    "What's Your Name?",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  )),
              Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 16, 0),
                    child: SizedBox(
                        height: 100,
                        width: 250,
                        child: TextFormField(
                          // Handles Form Validation for First Name
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                              // } else if (!isAlpha(value)) {
                              //   return 'Only Letters Please';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(labelText: 'Name'),
                          controller: firstNameController,
                        ))),
                // Padding(
                //     padding: const EdgeInsets.fromLTRB(0, 40, 16, 0),
                //     child: SizedBox(
                //         height: 100,
                //         width: 150,
                //         child: TextFormField(
                //           // Handles Form Validation for Last Name
                //           validator: (value) {
                //             if (value == null || value.isEmpty) {
                //               return 'Please enter your last name';
                //               // } else if (!isAlpha(value)) {
                //               //   return 'Only Letters Please';
                //             }
                //             return null;
                //           },
                //           decoration: const InputDecoration(labelText: 'Last Name'),
                //           controller: secondNameController,
                //         )))
              ]),
              Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 330,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate() /*&& isAlpha(firstNameController.text + secondNameController.text)*/) {
                              _updateUserValue(firstNameController.text + " " + secondNameController.text);
                              Navigator.pop(context);
                              widget.refreshCallback();
                            }
                          },
                          child: const Text('Update', style: TextStyle(fontSize: 15)),
                        ),
                      )))
            ]),
          ),
        ));
  }
}

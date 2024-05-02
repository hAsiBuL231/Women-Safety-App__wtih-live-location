import 'package:flutter/material.dart';

import '../../.data/network/network_api_services.dart';
import '../../.data/user_data_SharedPreferences/app_user_data.dart';
import '../../.resources/app_url/AppUrl.dart';
import '../../components/customText.dart';
import '../../models/user_model.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  //NetworkApiServices url = NetworkApiServices();
  Prefs prefs = Prefs();
  var userEmail;

  getname() async {
    userEmail = await prefs.get(prefs.email) ?? '';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getname();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User List')),
      body: FutureBuilder(
        future: NetworkApiServices().getApi(AppUrl.usersUrl),
        builder: (context, snapshot) {
          // List<Users> users = [];
          // for (var singleUser in snapshot.data) {
          //   Users user = Users(
          //       securityCode: singleUser["securityCode"],
          //       email: singleUser["email"],
          //       name: singleUser["name"],
          //       phone: singleUser["phone"],
          //       imageUrl: '',
          //       latitude: 0,
          //       longitude: 0);
          //
          //   //Adding user to the list.
          //   users.add(user);
          // }

          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          //if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          /// /////////////////////////////////// Finding the user data   //////////////////////////////
          // String? userEmail = FirebaseAuth.instance.currentUser!.email;

          var response = snapshot.data['results'];
          print(" \n \n UserList Print: $response , userEmail= $userEmail \n ");

          // var users = response.map((doc) => Users.fromJson(doc));
          // var matchedUsers = users.where((users) => users.email == userEmail).toList();

          // var matchedUsers = response.where((users) => users['email'] == userEmail).toList();
          // Users user = Users.fromJson(matchedUsers[0]);

          /// /////////////////////////////////// Finding the user data   //////////////////////////////

          return Padding(
            padding: const EdgeInsets.all(14),
            child: ListView.builder(
              itemCount: response.length,
              itemBuilder: (context, index) {
                Users user = Users.fromJson(response[index]);
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(3),
                  child: ListTile(
                    title: Text('Name: ${user.name}'),
                    subtitle: Text('Email: ${user.email} \nPhone: ${user.phone.toString()}\n'
                        'securityCode: ${user.securityCode} \n'),
                  ),
                );
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(3),
                  child: Column(children: [
                    customText(text: user.securityCode),
                    customText(text: user.email),
                  ]),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

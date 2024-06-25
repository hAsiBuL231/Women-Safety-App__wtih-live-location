import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../.resources/colours/app_colours.dart';
import '../../../.utils/Functions.dart';
import '../../../components/list_tile.dart';
import '../../../models/group_model.dart';
import '../../forms/AddMemberForm.dart';
import '../map_view/MapPage.dart';
import 'widgets/search_button.dart';
import 'widgets/verticalUserView.dart';
import 'package:http/http.dart' as http;

class GroupPageView extends StatefulWidget {
  final Group passedGroup;
  const GroupPageView({super.key, required this.passedGroup});

  @override
  State<GroupPageView> createState() => _GroupPageViewState();
}

class _GroupPageViewState extends State<GroupPageView> {
  List<Map<String, dynamic>> usersData = [];
  List<Map<String, dynamic>> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    fetchUsersData();
  }

  Future<void> _refreshData() async {
    setState(() {});
  }

  Future<void> fetchUsersData() async {
    List<String> userUrls = List<String>.from(widget.passedGroup.users);

    for (String userUrl in userUrls) {
      final response = await http.get(Uri.parse(userUrl));
      if (response.statusCode == 200) {
        setState(() {
          usersData.add(jsonDecode(response.body));
        });
      } else {
        print('Failed to fetch user data from URL: $userUrl');
      }
    }
    filteredUsers = usersData;
  }

  void filterUsers(String query) {
    List<Map<String, dynamic>> filtered = usersData.where((user) {
      return user["name"].toLowerCase().contains(query.toLowerCase()) ||
          user["email"].toLowerCase().contains(query.toLowerCase()) ||
          user["phone"].toString().contains(query);
    }).toList();

    setState(() {
      filteredUsers = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Members')),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            const SizedBox(height: 10),
            //customButton(onPress: () {}, bgColor: Colors.black,width: 200,text: "Create New Group"),
            //searchButton(),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 12),
              child: Row(mainAxisSize: MainAxisSize.max, children: [
                Expanded(
                    child: TextFormField(
                        //controller: _model.textController,
                        //focusNode: _model.textFieldFocusNode,
                        onChanged: (_value) => filterUsers(_value),
                        onFieldSubmitted: (_value) async => filterUsers(_value),
                        //autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Search members...',
                          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(width: 2), borderRadius: BorderRadius.circular(12)),
                          errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red, width: 2), borderRadius: BorderRadius.circular(12)),
                          focusedErrorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red, width: 2), borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          //fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                        ))),
                Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0), child: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.search_rounded))),
              ]),
            ),
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
              child: Text('Members in Group'),
            ),
            //verticalUserView(),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: filteredUsers.map((e) {
                    return Padding(
                        padding: const EdgeInsetsDirectional.all(12),
                        child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [BoxShadow(blurRadius: 4, color: Color(0x34090F13), offset: Offset(0, 2))],
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                ClipRRect(borderRadius: BorderRadius.circular(50), child: Image.network(e['imageUrl'], width: 60, height: 60, fit: BoxFit.cover)),
                                Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                                    child: Text(e['name'], style: TextStyle(color: AppColors.blackColour, fontSize: 12, fontFamily: GoogleFonts.manrope.toString()))),
                              ]),
                            )));
                  }).toList()),
            ),
            // ListView.builder(
            //   shrinkWrap: true,
            //   padding: EdgeInsets.zero,
            //   scrollDirection: Axis.horizontal,
            //   itemCount: usersData.length,
            //   itemBuilder: (context, index) {
            //     final userData = usersData[index];
            //     return Padding(
            //         padding: const EdgeInsetsDirectional.all(12),
            //         child: Container(
            //             width: 100,
            //             decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 boxShadow: const [BoxShadow(blurRadius: 4, color: Color(0x34090F13), offset: Offset(0, 2))],
            //                 borderRadius: BorderRadius.circular(8)),
            //             child: Padding(
            //               padding: const EdgeInsets.all(12),
            //               child: Column(
            //                   mainAxisSize: MainAxisSize.max,
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: <Widget>[
            //                     ClipRRect(
            //                         borderRadius: BorderRadius.circular(50),
            //                         child:
            //                             Image.network(userData['imageUrl'], width: 60, height: 60, fit: BoxFit.cover)),
            //                     Padding(
            //                         padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
            //                         child: Text(userData['name'],
            //                             style: TextStyle(
            //                                 color: AppColors.blackColour,
            //                                 fontSize: 12,
            //                                 fontFamily: GoogleFonts.manrope.toString()))),
            //                   ]),
            //             )));
            //     return customListTile(
            //         title: userData['name'],
            //         imageUrl: userData['imageUrl'],
            //         subTitle: 'See live location..',
            //         onPress: () => nextPage(MapPage(securityCode: userData['securityCode']), context));
            //   },
            // ),
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
              child: Text('Members list'),
            ),

            Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.end, children: [
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: FloatingActionButton.extended(
                    heroTag: 'heroTag<GroupPage>',
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    onPressed: () => nextPage(AddMemberForm(passedGroup: widget.passedGroup), context),
                    elevation: 5,
                    backgroundColor: AppColors.tertiary,
                    label: AutoSizeText("Add Member",
                        style: TextStyle(color: AppColors.primaryBackground, fontSize: 12, fontWeight: FontWeight.w800, fontFamily: GoogleFonts.manrope.toString())),
                  )),
            ]),
            const SizedBox(height: 10),
            // FutureBuilder(
            //   future: NetworkApiServices().getApi("${AppUrl.groupsUrl}/passedID"),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            //     if (snapshot.data['documents'] != null) {
            //       /// /////////////////////////////////// Finding the user data   //////////////////////////////
            //       var response = snapshot.data['documents'];
            //       var users = response.map((doc) => Users.fromJson(doc));
            //
            //       /// /////////////////////////////////// Finding the user data   //////////////////////////////
            //       // return ListView.builder(
            //       //   shrinkWrap: true,
            //       //   itemCount: widget.passedGroup.idList.length,
            //       //   itemBuilder: (context, index) {
            //       //     var matchedUsers = users.where((users) => users.securityCode == widget.passedGroup.idList[index]).toList();
            //       //     return customListTile(
            //       //         title: matchedUsers[0].name,
            //       //         imageUrl: matchedUsers[0].imageUrl,
            //       //         subTitle: 'See live location..',
            //       //         onPress: () => nextPage(MapPage(securityCode: matchedUsers[0].securityCode), context));
            //       //     //return customListTile(title: widget.idList[index]);
            //       //     //return customListTile(title: widget.passedGroup.users[index].name);
            //       //   },
            //       // );
            //     }
            //
            //     return Center(
            //         child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text("No member", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.aboreto.toString())),
            //     ));
            //   },
            // ),

            ListView.builder(
              shrinkWrap: true,
              itemCount: usersData.length,
              itemBuilder: (context, index) {
                final userData = usersData[index];
                return customListTile(
                    title: userData['name'],
                    imageUrl: userData['imageUrl'],
                    subTitle: 'See live location..',
                    onPress: () => nextPage(MapPage(securityCode: userData['securityCode']), context));
              },
            ),
          ]),
        ),
      ),
    );
  }
}

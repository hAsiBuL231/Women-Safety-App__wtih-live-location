import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../.data/network/network_api_services.dart';
import '../../../.data/user_data_SharedPreferences/app_user_data.dart';
import '../../../.resources/app_url/AppUrl.dart';
import '../../../.resources/colours/app_colours.dart';
import '../../../.utils/Functions.dart';
import '../../../components/list_tile.dart';
import '../../../models/group_model.dart';
import '../../forms/CreateGroupForm.dart';
import '../group_page_view/group_page_view.dart';

/// ///////////////////////////    Create new Group   ///////////////////////////
Widget groupListWidget(BuildContext context) {
  final userProvider = Provider.of<UserDataProvider>(context, listen: false);

  if (userProvider.userData != null) {
    return Column(children: [
      /// ///////////////////////////    Create new Group Button  ///////////////////////////

      Padding(
          padding: const EdgeInsets.all(10),
          child: FloatingActionButton.extended(
            onPressed: () => nextPage(const CreateGroupForm(), context),
            elevation: 10,
            backgroundColor: AppColours.tertiary,
            label: AutoSizeText("Create New Group",
                maxLines: 1,
                style: TextStyle(color: AppColours.primaryBackground, fontSize: 18, fontWeight: FontWeight.w800, fontFamily: GoogleFonts.manrope.toString())),
          )),

      /// ///////////////////////////    Group List from firebase ///////////////////////////

      FutureBuilder(
        future: NetworkApiServices().getApi("${AppUrl.usersUrl}${userProvider.userData?.securityCode}/groups/"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData) return Center(child: Text(snapshot.error.toString()));

          // var groups = snapshot.data['documents'];
          var groups = snapshot.data;
          print(" \n \n \n groupListWidget Snapshot:          ${snapshot.data}");

          if (groups == null) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("No group", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.aboreto.toString())),
            ));
          }

          return Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: groups.length,
              itemBuilder: (context, index) {
                print(" \n \n \n groupListWidget groups[index]:      ${groups[index]}");

                Group group = Group.fromJson(groups[index]);
                //print(" \n \n \n itemBuilder:      ${group.toJson()}");

                String? gId = group.groupId;
                String? gName = group.name.toString();
                String? gImage = group.imageUrl.toString();
                String? gLength = group.users.length.toString();

                return customListTile(title: gName, subTitle: 'Members: $gLength', imageUrl: gImage, onPress: () => nextPage(GroupPageView(passedGroup: group), context));
              },
            ),
          );
        },
      ),
    ]);
  } else {
    return const Text("Something is wrong!");
  }
}

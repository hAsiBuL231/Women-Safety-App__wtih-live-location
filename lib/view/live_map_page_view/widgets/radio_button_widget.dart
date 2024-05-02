import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/view_models/home_page_model/HomePageModel.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../.resources/colours/app_colours.dart';
import '../../../view_models/map_view_models/listen_location.dart';

final homePageVM = Get.put(HomePageModel());
final listenLocationVM = Get.put(ListenLocationProvider());

Widget radioButton(context) {
  return Obx(
    () => Card(
      color: AppColors.tertiary,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SwitchListTile.adaptive(
        value: homePageVM.switchListTileValue.value,
        onChanged: (newValue) async {
          homePageVM.switchListTileValue.value = newValue;
          //setState(() => switchListTileValue = newValue);
          if (newValue == true) {
            listenLocationVM.startListening();
            listenLocationVM.listenLocation(context);
          } else {
            listenLocationVM.stopListening();
          }
        },
        title: AutoSizeText('Enable Live Location',
            maxLines: 1, style: TextStyle(color: AppColors.primaryBackground, fontSize: 24, fontWeight: FontWeight.w800, fontFamily: GoogleFonts.manrope.toString())),
        subtitle: AutoSizeText('Friends can see your live location...',
            maxLines: 1, style: TextStyle(color: AppColors.primaryBackground, fontSize: 12, fontWeight: FontWeight.w500, fontFamily: GoogleFonts.manrope.toString())),
        tileColor: AppColors.tertiary,
        activeColor: AppColors.secondaryBackground,
        activeTrackColor: AppColors.primary,
        dense: false,
        controlAffinity: ListTileControlAffinity.trailing,
        contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 0, 16, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../.resources/colours/app_colours.dart';

verticalUserView() {
  return Container(
    width: double.infinity,
    height: 160,
    decoration: const BoxDecoration(),
    child: ListView(padding: EdgeInsets.zero, primary: false, shrinkWrap: true, scrollDirection: Axis.horizontal, children: [
      Padding(
          padding: const EdgeInsetsDirectional.all(12),
          child: Container(
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [BoxShadow(blurRadius: 4, color: Color(0x34090F13), offset: Offset(0, 2))],
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1614436163996-25cee5f54290?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fHVzZXJ8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      )),
                  Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                      child: Text('UserName', style: TextStyle(color: AppColors.blackColour, fontSize: 12, fontFamily: GoogleFonts.manrope.toString()))),
                  Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text('Remove',
                          style: TextStyle(color: AppColors.blackColour, fontSize: 12, fontWeight: FontWeight.w800, fontFamily: GoogleFonts.manrope.toString()))),
                ]),
              ))),
      Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
          child: Container(
              width: 100,
              //height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [BoxShadow(blurRadius: 4, color: Color(0x34090F13), offset: Offset(0, 2))],
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                          'https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover)),
                  Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                      child: Text('UserName', style: TextStyle(color: AppColors.blackColour, fontSize: 12, fontFamily: GoogleFonts.manrope.toString()))),
                  Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text('Remove',
                          style: TextStyle(color: AppColors.blackColour, fontSize: 12, fontWeight: FontWeight.w800, fontFamily: GoogleFonts.manrope.toString()))),
                ]),
              ))),
      Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
          child: Container(
              width: 100,
              //height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [BoxShadow(blurRadius: 4, color: Color(0x34090F13), offset: Offset(0, 2))],
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      )),
                  Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                      child: Text('UserName', style: TextStyle(color: AppColors.blackColour, fontSize: 12, fontFamily: GoogleFonts.manrope.toString()))),
                  Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text('Remove',
                          style: TextStyle(color: AppColors.blackColour, fontSize: 12, fontWeight: FontWeight.w800, fontFamily: GoogleFonts.manrope.toString()))),
                ]),
              ))),
    ]),
  );
}

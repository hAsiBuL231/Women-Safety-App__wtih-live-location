import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  // const CustomAppBar({super.key});
  Function? onTap;
  int? quoteIndex;
  CustomAppBar({this.onTap, this.quoteIndex});

  List sweetSayings = [
    "Your presence, lights up the whole room",
    "We admire,Your strong personality.",
    "We’ll help you In any way we can,",
    "You are Strong and courageous",
    'I say if I’m beautiful. I say if I’m strong',
    'Above all, be the heroine of your life, not the victim',
  ];

  @override
  Widget build(BuildContext context) {
    //Timer.periodic(Duration(seconds: 2), (timer) { });

    return GestureDetector(
      onTap: () => onTap!(),
      child: Container(
        // decoration: BoxDecoration(color: Colors.orangeAccent, borderRadius: BorderRadius.circular(20)),
        child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 10, top: 5, bottom: 10),
            child: Text(
              sweetSayings[quoteIndex!],
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}

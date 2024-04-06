import 'dart:math';

import 'package:flutter/material.dart';

import 'home_widgets/CustomCarouel.dart';
import 'home_widgets/custom_appBar.dart';
import 'home_widgets/EmergencyWidget.dart';
import 'home_widgets/SafeHome.dart';
import 'home_widgets/live_safe.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int qIndex = 0;
  getRandomQuote() {
    Random random = Random();
    setState(() => qIndex = random.nextInt(6));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            /// CustomAppBar
            //SizedBox(height: 10, child: Container(color: Colors.grey.shade100)),
            const SizedBox(height: 10),
            CustomAppBar(quoteIndex: qIndex, onTap: () => getRandomQuote()),
            const SizedBox(height: 5),
            //SizedBox(height: 10, child: Container(color: Colors.grey.shade100)),

            /// CustomAppBar

            Expanded(
              child: ListView(shrinkWrap: true, children: [
                const SizedBox(height: 10),
                /*const Align(
                  alignment: Alignment.center,
                  child: Padding(padding: EdgeInsets.all(8.0), child: Text("In case of emergency dial me", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                ),*/

                /// EmergencyWidget
                const EmergencyWidget(),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.center,
                  child: Padding(padding: EdgeInsets.all(8.0), child: Text("Explore your power", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                ),
                const SizedBox(height: 10),

                /// CustomCarousel - imageSliders
                CustomCarousel(),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.center,
                  child: Padding(padding: EdgeInsets.all(8.0), child: Text("Explore LiveSafe", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                ),
                const SizedBox(height: 10),

                /// LiveSafe
                const LiveSafe(),

                /// SafeHome
                SafeHome(),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../live_map_page_view/LiveMapPage.dart';
import '../web/NewWebView.dart';
import 'home_page_view/HomePageView.dart';
import 'review_page_view/review_page.dart';


class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int currentIndex = 0;
  List<Widget> pages = [
    HomePageView(),
    LiveMapPage(),
    MyWidget(),
    LiveMapPage(),
    const ReviewPage(),
  ];
  onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(currentIndex: currentIndex, type: BottomNavigationBarType.fixed, onTap: onTapped, items: const [
        BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
        BottomNavigationBarItem(label: 'Live Map', icon: Icon(Icons.contacts)),
        BottomNavigationBarItem(label: 'Chats', icon: Icon(Icons.chat)),
        BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
        BottomNavigationBarItem(label: 'Reviews', icon: Icon(Icons.reviews))
      ]),
    );
  }
}

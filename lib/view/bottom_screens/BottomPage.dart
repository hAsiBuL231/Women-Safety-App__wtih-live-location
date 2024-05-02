import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/view/user_view/UserView.dart';

import '../live_map_page_view/LiveMapPage.dart';
import 'contacts_view/add_contacts.dart';
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
    const HomePageView(),
    const LiveMapPage(),
    const AddContactsPage(),
    // UsersList(),
    const UserView(),
    // const ReviewPage(),
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
        BottomNavigationBarItem(label: 'Contacts', icon: Icon(Icons.contacts)),
        // BottomNavigationBarItem(label: 'Chats', icon: Icon(Icons.chat)),
        BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
        // BottomNavigationBarItem(label: 'Reviews', icon: Icon(Icons.reviews))
      ]),
    );
  }
}

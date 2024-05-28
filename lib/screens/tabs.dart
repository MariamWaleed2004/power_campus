import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:power_campus/screens/home.dart';
import 'package:power_campus/screens/schedule.dart';
import 'package:power_campus/screens/user.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const HomeScreen();
    var activePageTitle = 'Your Courses';

    if (_selectedPageIndex == 1) {
      activePage = const ScheduleScreen();
      activePageTitle = 'Your Schedule';
    }

    if (_selectedPageIndex == 2) {
      activePage = const UserScreen();
      activePageTitle = 'Your Profile';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 61, 92, 133),
        title: Text(
          activePageTitle,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 61, 92, 133),
        fixedColor: Colors.white,
        onTap: selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_sharp), label: 'Me'),
        ],
      ),
    );
  }
}

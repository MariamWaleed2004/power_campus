import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:power_campus/screens/cart.dart';
import 'package:power_campus/screens/categories.dart';
import 'package:power_campus/screens/home.dart';
import 'package:power_campus/screens/schedule.dart';
import 'package:power_campus/screens/user.dart';
import 'package:power_campus/screens/user_courses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({
    super.key,
  });

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  String _currentUsername = '';

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _currentUsername = userDoc['username'] ?? 'User';
      });
    }
  }

  void selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _cartPage() {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => CartScreen()));
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = HomeScreen();
    var activePageTitle = 'Hello $_currentUsername !';

    if (_selectedPageIndex == 1) {
      activePage = const UserCourses();
      activePageTitle = 'My Courses';
    }

    if (_selectedPageIndex == 2) {
      activePage = const UserScreen();
      activePageTitle = 'My Profile';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 228, 224, 224),
        title: Text(
          activePageTitle,
          style: const TextStyle(
            color: Color.fromARGB(255, 22, 39, 83),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _cartPage,
            icon: const Icon(
              Icons.shopping_cart,
              color: Color.fromARGB(255, 22, 39, 83),
            ),
          ),
        ],
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 67, 83, 102),
        fixedColor: Colors.white,
        onTap: selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule), label: 'My courses'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_sharp), label: 'Me'),
        ],
      ),
    );
  }
}

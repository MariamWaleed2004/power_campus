import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String _currentUsername = '';
  String _currentUserEmail = '';

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
        _currentUserEmail = userDoc['email'] ?? 'Email';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 224, 224),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.account_circle_sharp,
            size: 110,
            color: const Color.fromARGB(255, 22, 39, 83),
          ),
          const SizedBox(height: 10),
          Text(
            _currentUsername,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 22, 39, 83),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            //Icon(Icons.email),
            const SizedBox(
              width: 15,
            ),
            Text(
              _currentUserEmail,
              style: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 22, 39, 83),
              ),
            ),
          ]),
          const SizedBox(height: 40),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(fontSize: 15),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                const Text(
                  'Account Security',
                  style: TextStyle(fontSize: 15),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                const Text(
                  'About Us',
                  style: TextStyle(fontSize: 15),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 22, 39, 83),
                ),
              ))
        ],
      ),
    );
  }
}

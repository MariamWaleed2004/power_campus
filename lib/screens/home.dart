import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:power_campus/models/course_item.dart';
import 'package:power_campus/widgets/add_course.dart';

void clearSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List<Column> addedcourseWidgets = [];
  final authenticatedUser = FirebaseAuth.instance.currentUser!;

  void _courseButton() {
    Navigator.of(context).push<CourseItem>(
      MaterialPageRoute(
        builder: (ctx) => const AddCourse(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 18, 29, 46),
        body: Column(children: [
          Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Courses')
                      .where('addedBy.${authenticatedUser.uid}',
                          isEqualTo: true)
                      .snapshots(),
                  builder: (ctx, addedcoursesSnapchots) {
                    if (addedcoursesSnapchots.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!addedcoursesSnapchots.hasData ||
                        addedcoursesSnapchots.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No cources found'),
                      );
                    }

                    if (addedcoursesSnapchots.hasError) {
                      return const Center(
                        child: Text('Something went wrong...'),
                      );
                    }

                    final addedCourses =
                        addedcoursesSnapchots.data!.docs;

                    return ListView.builder(
                        itemCount: addedCourses.length,
                        itemBuilder: (ctx, index) {
                          final addedCourse = addedCourses[index].data();
                          final courseId = addedCourse['id'];
                          final courseTitle = addedCourse['title'];

                          return Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Card(
                              color: const Color.fromARGB(255, 216, 209, 209),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        courseId,
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  courseTitle,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child:  ElevatedButton(
                              onPressed: clearSharedPreferences,
                              child: Text('Remove Course'),
                                   ),
                               ),
                            ],
                          )
                       ],
                     ),
                   ),    
                 );
               });
          })),
          ElevatedButton(
            onPressed: _courseButton,
            child: const Text('Add Course'),
          ),
    ]));
  }
}

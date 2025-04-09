import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:power_campus/screens/categories.dart';
import 'package:power_campus/screens/course.dart';
import 'package:power_campus/screens/course_brief.dart';
import 'package:power_campus/screens/user_courses.dart';

import 'package:provider/provider.dart';

import 'package:power_campus/models/course_item.dart';
import 'package:power_campus/screens/courses.dart';
import 'package:power_campus/providers/add_remove_courses_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List<Column> addedcourseWidgets = [];
  final authenticatedUser = FirebaseAuth.instance.currentUser!;

  // @override
  // void initState() {
  //   super.initState();
  //   // Load the added courses and last opened courses
  //   final addedCoursesProvider =
  //       Provider.of<AddedCoursesProvider>(context, listen: false);
  //   addedCoursesProvider.loadAddedCourseIds();
  //   addedCoursesProvider.loadLastOpenedCourses(); // Ensure you have this method
  // }

  void _categories() {
    Navigator.of(context).push<CourseItem>(
      MaterialPageRoute(
        builder: (ctx) => const CategoriesScreen(),
      ),
    );
  }

  Future<void> resetPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // This will reset all stored preferences
  }

  @override
  Widget build(BuildContext context) {
    final addedCoursesProvider = Provider.of<AddedCoursesProvider>(context);
    // final lastOpenedCourses = addedCoursesProvider.lastOpenedCourse;

    // final User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 224, 224),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'See all the categories',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 22, 39, 83),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: ElevatedButton(
              onPressed: _categories,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 135, 181, 218)),
              child: const Text(
                'Categories',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Development courses recommended for you',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 22, 39, 83),
              ),
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Categories')
                .doc('Development')
                .collection('Courses')
                .snapshots(),
            builder: (ctx, coursesSnapshots) {
              if (coursesSnapshots.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!coursesSnapshots.hasData ||
                  coursesSnapshots.data!.docs.isEmpty) {
                return const Center(child: Text('No courses found.'));
              }

              final coursesData = coursesSnapshots.data!.docs;

              return SizedBox(
                height: 280,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: coursesData.length,
                    itemBuilder: (ctx, index) {
                      final course = coursesData[index];
                      final courseId = course['id'];
                      final courseTitle = course['title'];
                      final courseImage = course['image'];
                      final coursePrice = course['price'];
                      final cousreInstructor = course['instructor'];
                      final courseDescription = course['description'];
                      final courseVideo = course['videoUrl'];
                      final courseLanguage = course['language'];
                      final courseHours = course['hours'];

                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 20, right: 10),
                        child:
                            Column(mainAxisSize: MainAxisSize.max, children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => CourseBrief(
                                    courseId: courseId,
                                    courseTitle: courseTitle,
                                    courseDescription: courseDescription,
                                    courseVideo: courseVideo,
                                    courseImage: courseImage,
                                    cousreInstructor: cousreInstructor,
                                    courseLanguage: courseLanguage,
                                    courseHours: courseHours,
                                    coursePrice: coursePrice,
                                    categoryname: 'Development',
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 200,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 16, 28, 54))),
                                  child: ClipRRect(
                                    //borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      courseImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    courseId,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    courseTitle,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    cousreInstructor,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "$coursePrice EGP",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      );
                    }),
              );
            },
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              'Newest courses in Business',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 22, 39, 83),
              ),
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Categories')
                .doc('Business')
                .collection('Courses')
                .snapshots(),
            builder: (ctx, coursesSnapshots) {
              if (coursesSnapshots.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!coursesSnapshots.hasData ||
                  coursesSnapshots.data!.docs.isEmpty) {
                return const Center(child: Text('No courses found.'));
              }

              final coursesData = coursesSnapshots.data!.docs;

              return SizedBox(
                height: 280,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: coursesData.length,
                    itemBuilder: (ctx, index) {
                      final course = coursesData[index];
                      final courseId = course['id'];
                      final courseTitle = course['title'];
                      final courseImage = course['image'];
                      final coursePrice = course['price'];
                      final cousreInstructor = course['instructor'];
                      final courseDescription = course['description'];
                      final courseVideo = course['videoUrl'];
                      final courseLanguage = course['language'];
                      final courseHours = course['hours'];

                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 20, right: 10),
                        child:
                            Column(mainAxisSize: MainAxisSize.max, children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => CourseBrief(
                                    courseId: courseId,
                                    courseTitle: courseTitle,
                                    courseDescription: courseDescription,
                                    courseVideo: courseVideo,
                                    courseImage: courseImage,
                                    cousreInstructor: cousreInstructor,
                                    courseLanguage: courseLanguage,
                                    courseHours: courseHours,
                                    coursePrice: coursePrice,
                                    categoryname: 'Business',
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 200,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 16, 28, 54))),
                                  child: ClipRRect(
                                    //borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      courseImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    courseId,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    courseTitle,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    cousreInstructor,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "$coursePrice EGP",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      );
                    }),
              );
            },
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed: resetPreferences, child: Text('reset'))
        ]),
      ),
    );
  }
}

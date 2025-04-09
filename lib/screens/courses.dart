import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:power_campus/screens/course.dart';
import 'package:power_campus/screens/course_brief.dart';
import 'package:provider/provider.dart';
import 'package:power_campus/providers/add_remove_courses_provider.dart';

class CoursesScreen extends StatefulWidget {
  final String categoryname;

  const CoursesScreen({
    super.key,
    required this.categoryname,
  });

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<Column> courseWidgets = [];

  @override
  Widget build(BuildContext context) {
    final addedCoursesProvider = Provider.of<AddedCoursesProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Color.fromARGB(255, 7, 6, 41),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              widget.categoryname,
              style: const TextStyle(fontSize: 37, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Courses To Get You Started',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const Icon(
              Icons.expand_more_sharp,
              size: 40,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Categories')
                  .doc(widget.categoryname)
                  .collection('Courses')
                  .snapshots(),
              builder: (ctx, coursesSnapshots) {
                if (coursesSnapshots.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final coursesData = coursesSnapshots.data!.docs;

                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                      final isCourseAdded = addedCoursesProvider.addedCourseIds
                          .contains(courseId);
                      final courseAddedByCurrentUser =
                          coursesSnapshots.data!.docs.isNotEmpty;

                      return Column(mainAxisSize: MainAxisSize.max, children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => CourseBrief(
                                            courseId: courseId,
                                            courseTitle: courseTitle,
                                            courseDescription:
                                            courseDescription,
                                            courseVideo: courseVideo,
                                            courseImage: courseImage,
                                            cousreInstructor: cousreInstructor,
                                            courseLanguage: courseLanguage,
                                            courseHours: courseHours,
                                            coursePrice: coursePrice,
                                            categoryname: widget.categoryname,
                                          )));
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 300,
                                  height: 180,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              Color.fromARGB(255, 16, 28, 54))),
                                  child: ClipRRect(
                                    //borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      courseImage,
                                      width: 150,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, top: 10),
                                    child: Text(
                                      courseId,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, top: 10),
                                    child: Text(
                                      courseTitle,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 30, top: 5),
                                    child: Text(
                                      cousreInstructor,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 30, top: 5),
                                    child: Text(
                                      "$coursePrice EGP",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]);
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// void _addCourse(
//   String courseId,
//   String courseTitle,
//   String courseDescription,
//   String courseVideo,
//   String courseImage,
//   String cousreInstructor,
//   String courseLanguage,
//   String courseHours,
//   String courseCategory,
//   AddedCoursesProvider addedCoursesProvider,
// ) async {
//   final user = FirebaseAuth.instance.currentUser!;
//   final userData =
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

//   addedCoursesProvider.addCourseId(courseId);

//   final userDocRef =
//       FirebaseFirestore.instance.collection('users').doc(user.uid);

//   final usersSubcollectionRef = userDocRef.collection('addedCourses');

//   Map<String, dynamic> courseData = {
//     'courseId': courseId,
//     'courseTitle': courseTitle,
//     'addedAt': Timestamp.now(),
//     'courseDescription': courseDescription,
//     'courseVideo': courseVideo,
//     'courseImage': courseImage,
//     'cousreInstructor': cousreInstructor,
//     'courseLanguage': courseLanguage,
//     'courseHours': courseHours,
//     'courseCategory': courseCategory,
//   };

//   usersSubcollectionRef.doc(courseId).set(courseData).then((value) {
//     print('Document with custom ID added successfully!');
//   }).catchError((error) {
//     print('Error adding document: $error');
//   });

//   final coursesCollection =
//       FirebaseFirestore.instance.collection('Courses').doc(courseId);

//   final coursesSubcollectionRef = coursesCollection.collection('addedBy');

//   Map<String, dynamic> _userData = {
//     'userId': user.uid,
//     'username': userData.data()!['username'],
//     'addedAt': Timestamp.now(),
//   };

//   coursesSubcollectionRef.doc(user.uid).set(_userData).then((value) {
//     print('Document with custom ID added successfully!');
//   }).catchError((error) {
//     print('Error adding document: $error');
//   });
// }


// void _addCourse(
//     String courseId,
//     String courseTitle,
//     String courseDescription,
//     String courseVideo,
//     String courseImage,
//     String cousreInstructor,
//     String courseLanguage,
//     String courseHours,
//     String courseCategory,
//     AddedCoursesProvider addedCoursesProvider,
//   ) async {
//     setState(() {
//       _isAdding = true;
//     });

//     final user = FirebaseAuth.instance.currentUser!;
//     final userData = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .get();

//     addedCoursesProvider.addCourseId(courseId);

//     // final courseDocRef =
//     //     FirebaseFirestore.instance.collection('Courses').doc(courseId);

//     // final subcollectionRef = courseDocRef.collection('addedBy');

//     // await subcollectionRef.add({
//     //   'userId': user.uid,
//     //   'username': userData.data()!['username'],
//     //   'addedAt': Timestamp.now(),
//     // });

//     final userDocRef =
//         FirebaseFirestore.instance.collection('users').doc(user.uid);

//     final usersSubcollectionRef = userDocRef.collection('addedCourses');

//     Map<String, dynamic> courseData = {
//       'courseId': courseId,
//       'courseTitle': courseTitle,
//       'addedAt': Timestamp.now(),
//       'courseDescription': courseDescription,
//       'courseVideo': courseVideo,
//       'courseImage': courseImage,
//       'cousreInstructor': cousreInstructor,
//       'courseLanguage': courseLanguage,
//       'courseHours': courseHours,
//       'courseCategory': courseCategory,
//     };

//     usersSubcollectionRef.doc(courseId).set(courseData).then((value) {
//       print('Document with custom ID added successfully!');
//     }).catchError((error) {
//       print('Error adding document: $error');
//     });

//     final coursesCollection =
//         FirebaseFirestore.instance.collection('Courses').doc(courseId);

//     final coursesSubcollectionRef = coursesCollection.collection('addedBy');

//     Map<String, dynamic> _userData = {
//       'userId': user.uid,
//       'username': userData.data()!['username'],
//       'addedAt': Timestamp.now(),
//     };

//     coursesSubcollectionRef.doc(user.uid).set(_userData).then((value) {
//       print('Document with custom ID added successfully!');
//     }).catchError((error) {
//       print('Error adding document: $error');
//     });

//     // await usersSubcollectionRef.add({
//     //   'courseId': courseId,
//     //   'courseTitle': courseTitle,
//     //   'addedAt': Timestamp.now(),
//     // });

//     setState(() {
//       _isAdding = false;
//       isCourseAdded = true;
//     });
//   }

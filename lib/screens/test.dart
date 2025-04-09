// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';
// import 'package:power_campus/providers/add_remove_courses_provider.dart';

// class AddCourseScreen extends StatefulWidget {
//   final String categoryname;

//   const AddCourseScreen({
//     super.key,
//     required this.categoryname,
//   });


//   @override
//   State<AddCourseScreen> createState() {
//     return _AddCourseState();
//   }
// }

// class _AddCourseState extends State<AddCourseScreen> {
//   List<Column> courseWidgets = [];

//   var _isAdding = false;
//   var isCourseAdded = false;

//   @override
//   void initState() {
//     super.initState();
//     Provider.of<AddedCoursesProvider>(context, listen: false)
//         .loadAddedCourseIds();
//   }

//   void _addCourse(
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

//   @override
//   Widget build(BuildContext context) {
//     final addedCoursesProvider = Provider.of<AddedCoursesProvider>(context);

//     return Scaffold(
//         appBar: AppBar(
//           foregroundColor: Colors.white,
//           title: const Text('Available Cources'),
//           backgroundColor: const Color.fromARGB(255, 3, 15, 32),
//         ),
//         body: StreamBuilder(
//             stream:
//                 FirebaseFirestore.instance
//                 .collection('Categories')               
//                 .snapshots(),
//             builder: (ctx, categoriesSnapchots) {
//               if (categoriesSnapchots.connectionState ==
//                   ConnectionState.waiting) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//               final categoriesData = categoriesSnapchots.data!.docs;

//               return ListView.builder(
//                 itemCount: categoriesData.length,
//                 itemBuilder: (ctx, index) {
//                   final category = categoriesData[index];
//                   final categoryName = category['name'];
//                   print(categoryName);

//                   return StreamBuilder(
//                     stream: FirebaseFirestore.instance
//                         .collection('Categories')
//                         .doc(categoryName)
//                         .collection('Courses')
//                         .snapshots(),
//                     builder: (ctx, coursesSnapshots) {
//                       if (coursesSnapshots.connectionState ==
//                           ConnectionState.waiting) {
//                         return const Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       }
//                       final coursesData = coursesSnapshots.data!.docs;

//                       return ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: coursesData.length,
//                           itemBuilder: (ctx, index) {
//                             final course = coursesData[index];
//                             final courseId = course['id'];
//                             final isCourseAdded = addedCoursesProvider
//                                 .addedCourseIds
//                                 .contains(courseId);
//                             final courseAddedByCurrentUser =
//                                 coursesSnapshots.data!.docs.isNotEmpty;

//                             return Column(
//                               children: [
//                                 Padding(
//                                     padding: const EdgeInsets.only(top: 25),
//                                     child: Card(
//                                       color: const Color.fromARGB(
//                                           255, 216, 209, 209),
//                                       child: Column(
//                                           mainAxisSize: MainAxisSize.max,
//                                           children: [
//                                             Align(
//                                               alignment: Alignment.topLeft,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(10),
//                                                 child: Text(
//                                                   course['id'],
//                                                   style: const TextStyle(
//                                                     fontSize: 20,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(10),
//                                                   child: Text(
//                                                     course['title'],
//                                                     style: const TextStyle(
//                                                         fontSize: 10),
//                                                   ),
//                                                 ),
//                                                 //if (_isAdding) const CircularProgressIndicator(),
//                                                 //if (!_isAdding)
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8.0),
//                                                   child: ElevatedButton(
//                                                     onPressed: isCourseAdded &&
//                                                             courseAddedByCurrentUser
//                                                         ? null
//                                                         : () => _addCourse(
//                                                               course['id'],
//                                                               course['title'],
//                                                               course[
//                                                                   'description'],
//                                                               course[
//                                                                   'videoUrl'],
//                                                               course['image'],
//                                                               course[
//                                                                   'instructor'],
//                                                               course[
//                                                                   'language'],
//                                                               course['hours'],
//                                                               course[
//                                                                   'category'],
//                                                               addedCoursesProvider,
//                                                             ),
//                                                     child: isCourseAdded &&
//                                                             courseAddedByCurrentUser
//                                                         ? const Text(
//                                                             'Course Added')
//                                                         : const Text(
//                                                             'Add Course'),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ]),
//                                     )),
//                               ],
//                             );
//                           });
//                     },
//                   );

//                   // final user = FirebaseAuth.instance.currentUser;
//                   // final userId = user != null ? user.uid : null;
//                 },
//               );
//             }));
//   }
// }

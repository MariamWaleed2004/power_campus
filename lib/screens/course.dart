import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:power_campus/widgets/course_custom_video_player.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:power_campus/providers/add_remove_courses_provider.dart';
import 'package:power_campus/screens/home.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.courseDescription,
    required this.courseVideo,
    required this.courseImage,
    required this.cousreInstructor,
    required this.courseLanguage,
    required this.courseHours,
  });

  final String courseId;
  final String courseTitle;
  final String courseDescription;
  final String courseVideo;
  final String courseImage;
  final String cousreInstructor;
  final String courseLanguage;
  final String courseHours;

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final authenticatedUser = FirebaseAuth.instance.currentUser!;
  var _isRemoving = false;

  @override
  void initState() {
    super.initState();
    Provider.of<AddedCoursesProvider>(context, listen: false)
        .loadAddedCourseIds();
  }

  // void _removeCourse(
  //   String courseId,
  //   String coursePrice,
  //   AddedCoursesProvider addedCoursesProvider,
  // ) async {
  //   setState(() {
  //     _isRemoving = true;
  //     addedCoursesProvider.removeCourseId(courseId);
  //   });

  //   final userCollection = FirebaseFirestore.instance.collection('users');
  //   final coursesCollection = FirebaseFirestore.instance.collection('Courses');

  //   try {
  //     await userCollection
  //         .doc(authenticatedUser.uid)
  //         .collection('addedCourses')
  //         .doc(courseId)
  //         .delete();

  //     await coursesCollection
  //         .doc(courseId)
  //         .collection('addedBy')
  //         .doc(authenticatedUser.uid)
  //         .delete();

  //     addedCoursesProvider.removeCourseId(courseId);
  //   } catch (error) {
  //     print('Error deleting course: $error');
  //   } finally {
  //     setState(() {
  //       _isRemoving = false;
  //     });
  //   }
  //   Navigator.of(context).pop(); // Just pop the current CourseScreen
  //   Navigator.of(context).pushReplacement(MaterialPageRoute(
  //     builder: (ctx) => HomeScreen(),
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    final addedCoursesProvider = Provider.of<AddedCoursesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.courseId,
          style: const TextStyle(
            color: Color.fromARGB(255, 22, 39, 83),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(widget.courseImage),
              ),
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, top: 5),
                child: Text(
                  widget.courseTitle,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 22, 39, 83),
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 5, left: 12, right: 8),
              child: Text(
                widget.courseDescription,
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                const Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text('Created By:'),
                    )),
                const SizedBox(width: 5),
                Text(
                  widget.cousreInstructor,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 51, 104, 148),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 7),

            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                children: [
                  const Icon(Icons.alarm_on, size: 17),
                  const SizedBox(width: 10),
                  Text('${widget.courseHours} hours')
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                children: [
                  const Icon(Icons.language, size: 17),
                  const SizedBox(width: 10),
                  Text(widget.courseLanguage)
                ],
              ),
            ),

            const SizedBox(height: 40),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 22, 39, 83),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'Here is your course Video:',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: CourseCustomVideoPlayer(courseVideo: widget.courseVideo),
              ),
            ),

            // Column(
            //   children: [
            //     const Text(
            //       'Your Rating',
            //       style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //         color: Color.fromARGB(255, 22, 39, 83),
            //       ),
            //     ),
            //     const SizedBox(
            //       height: 10,
            //     ),
            //     RatingBar.builder(
            //       initialRating: 0,
            //       minRating: 1,
            //       allowHalfRating: true,
            //       direction: Axis.horizontal,
            //       itemPadding: const EdgeInsets.symmetric(horizontal: 4),
            //       itemCount: 6,
            //       itemSize: 25,
            //       itemBuilder: (ctx, _) => Icon(
            //         Icons.star,
            //         color: Colors.amber[300],
            //         size: 20,
            //       ),
            //       onRatingUpdate: (rating) {},
            //     ),
            // if (_isRemoving)
            //   const Padding(
            //     padding: EdgeInsets.all(12),
            //     child: CircularProgressIndicator(),
            //   ),
            // if (!_isRemoving)
            //   Align(
            //     alignment: Alignment.center,
            //     child: IconButton(
            //       icon: const Icon(Icons.delete_outline),
            //       onPressed: () =>
            //           _removeCourse(widget.courseId, addedCoursesProvider),
            //     ),
            //   ),
            //   ],
            // )

            // Card(
            //     child: Row(
            //   children: [
            //     const Icon(Icons.file_open),
            //     TextButton(
            //       onPressed: () {
            //         OpenFile.open('assets/powerpoint/NU-CSCE101-lec1.pptx');
            //       },
            //       child: const Text('NU-CSCE101-lec1'),
            //     ),
            //   ],
            // ),
            // ),
          ],
        ),
      ),
    );
  }
}

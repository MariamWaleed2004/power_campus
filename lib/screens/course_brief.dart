import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:power_campus/screens/cart.dart';
import 'package:power_campus/screens/course.dart';
import 'package:power_campus/widgets/course_custom_video_player.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:power_campus/providers/add_remove_courses_provider.dart';
import 'package:power_campus/screens/home.dart';

//import 'package:power_campus/providers/add_remove_courses_provider.dart';

class CourseBrief extends StatefulWidget {
  const CourseBrief({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.courseDescription,
    required this.courseVideo,
    required this.courseImage,
    required this.cousreInstructor,
    required this.courseLanguage,
    required this.courseHours,
    required this.coursePrice,
    required this.categoryname,
  });

  final String courseId;
  final String courseTitle;
  final String courseDescription;
  final String courseVideo;
  final String courseImage;
  final String cousreInstructor;
  final String courseLanguage;
  final String courseHours;
  final String coursePrice;
  final String categoryname;

  @override
  State<CourseBrief> createState() => _CourseBriefState();
}

class _CourseBriefState extends State<CourseBrief> {
  late final AddedCoursesProvider addedCoursesProvider;
  final authenticatedUser = FirebaseAuth.instance.currentUser!;
  var _isRemoving = false;
  var _isAdding = false;
  var isCourseAdded = false;

  @override
  void initState() {
    super.initState();
    addedCoursesProvider =
        Provider.of<AddedCoursesProvider>(context, listen: false);
    isCourseAdded =
        addedCoursesProvider.addedCourseIds.contains(widget.courseId);
  }

  void _addToCart(
    String courseId,
    String courseTitle,
    String courseDescription,
    String courseVideo,
    String courseImage,
    String cousreInstructor,
    String courseLanguage,
    String courseHours,
    String coursePrice,
    AddedCoursesProvider addedCoursesProvider,
  ) async {
    setState(() {
      _isAdding = true;
    });

    double coursesPrice = double.tryParse(coursePrice) ?? 0.0;

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    final usersSubcollectionRef = userDocRef.collection('userCart');

    Map<String, dynamic> courseData = {
      'courseId': courseId,
      'courseTitle': courseTitle,
      'courseDescription': courseDescription,
      'courseVideo': courseVideo,
      'courseImage': courseImage,
      'cousreInstructor': cousreInstructor,
      'courseLanguage': courseLanguage,
      'courseHours': courseHours,
      'coursePrice': coursePrice,
      'addedAt': Timestamp.now(),
    };
    addedCoursesProvider.addCourseId(courseId);

    usersSubcollectionRef.doc(courseId).set(courseData).then((value) {
      print('Document with custom ID added to cart successfully!');
    }).catchError((error) {
      print('Error adding document: $error');
    });

    setState(() {
      _isAdding = false;
      isCourseAdded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final addedCoursesProvider = Provider.of<AddedCoursesProvider>(context);
    final isCourseAdded =
        addedCoursesProvider.addedCourseIds.contains(widget.courseId);
    final isCoursePurchased =
        addedCoursesProvider.purchasedCourseIds.contains(widget.courseId);
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
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 20),
                child: Text(
                  'Sections',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: Color.fromARGB(255, 22, 39, 83),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Section 1 - Learning the first section',
                        style: TextStyle(
                          fontSize: 19,
                          color: Color.fromARGB(255, 107, 99, 99),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: Color.fromARGB(255, 22, 39, 83),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Section 2 - Learning the sec. section',
                        style: TextStyle(
                          fontSize: 19,
                          color: Color.fromARGB(255, 107, 99, 99),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: Color.fromARGB(255, 22, 39, 83),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Section 3 - Learning the third section',
                        style: TextStyle(
                          fontSize: 19,
                          color: Color.fromARGB(255, 107, 99, 99),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: Color.fromARGB(255, 22, 39, 83),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Section 4 - Learning the forth section',
                        style: TextStyle(
                          fontSize: 19,
                          color: Color.fromARGB(255, 107, 99, 99),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: Color.fromARGB(255, 22, 39, 83),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Section 5 - Learning the fifth section',
                        style: TextStyle(
                          fontSize: 19,
                          color: Color.fromARGB(255, 107, 99, 99),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Requirements',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 12, bottom: 20, right: 100),
                child: Text(
                  '- The requirements or prerequisites for taking the course are a basic understanding of AI concepts. No needed advanced technical skills are needed',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: 320,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isAdding
                      ? null
                      : () {
                          if (isCoursePurchased) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => CourseScreen(
                                          courseId: widget.courseId,
                                          courseTitle: widget.courseTitle,
                                          courseDescription:
                                              widget.courseDescription,
                                          courseVideo: widget.courseVideo,
                                          courseHours: widget.courseHours,
                                          courseImage: widget.courseImage,
                                          courseLanguage: widget.courseLanguage,
                                          cousreInstructor:
                                              widget.cousreInstructor,
                                        )));
                          } else if (isCourseAdded) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => CartScreen()));
                          } else {
                            _addToCart(
                              widget.courseId,
                              widget.courseTitle,
                              widget.courseDescription,
                              widget.courseVideo,
                              widget.courseImage,
                              widget.cousreInstructor,
                              widget.courseLanguage,
                              widget.courseHours,
                              widget.coursePrice,
                              addedCoursesProvider,
                            );
                          }
                        },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 16, 38, 56)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: _isAdding
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(5),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: _isAdding
                                ? CircularProgressIndicator()
                                : Text(isCoursePurchased
                                    ? 'Go to course'
                                    : (isCourseAdded
                                        ? 'Go to cart'
                                        : 'Add to cart')),
                          ),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

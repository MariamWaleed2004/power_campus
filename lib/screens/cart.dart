import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:power_campus/providers/add_remove_courses_provider.dart';
import 'package:power_campus/screens/user_courses.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  CartScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  final authenticatedUser = FirebaseAuth.instance.currentUser!;
  var _isRemoving = false;
  var _isBuying = false;
  var _isAddingToUserCourses = false;
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
  }

  void _removeCourse(
    String courseId,
    double coursePrice,
    AddedCoursesProvider addedCoursesProvider,
  ) async {
    setState(() {
      _isRemoving = true;
    });

    await addedCoursesProvider.removeCourseId(courseId);

    final userCollection = FirebaseFirestore.instance.collection('users');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(courseId);
    try {
      await userCollection
          .doc(authenticatedUser.uid)
          .collection('userCart')
          .doc(courseId)
          .delete();
    } catch (error) {
      print('Error deleting course: $error');
    }

    setState(() {
      _isRemoving = false;
    });
  }

  // void _calculateTotalPrice(List<Map<String, dynamic>> courses) {
  //   double total = 0.0;
  //   for (var course in courses) {
  //     final coursePriceString = course['coursePrice'] as String;
  //     final coursePrice = double.tryParse(coursePriceString) ?? 0.0;
  //     total += coursePrice;
  //   }
  // }

  void _buyNow(
    String courseId,
    String courseTitle,
    String courseDescription,
    String courseVideo,
    String courseImage,
    String cousreInstructor,
    String courseLanguage,
    String courseHours,
    double coursePrice,
    AddedCoursesProvider addedCoursesProvider,
  ) async {
    setState(() {
      _isBuying = true;
      _isAddingToUserCourses = true;
    });

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    final usersSubcollectionRef = userDocRef.collection('userCourses');

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
    Provider.of<AddedCoursesProvider>(context, listen: false)
        .purchaseCourseId(courseId);

    usersSubcollectionRef.doc(courseId).set(courseData).then((value) {
      print('Document with custom ID added to cart successfully!');
    }).catchError((error) {
      print('Error adding document: $error');
    });

    await addedCoursesProvider.removeCourseId(courseId);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userCollection = FirebaseFirestore.instance.collection('users');

    await prefs.remove(courseId);
    try {
      await userCollection
          .doc(authenticatedUser.uid)
          .collection('userCart')
          .doc(courseId)
          .delete();
    } catch (error) {
      print('Error deleting course: $error');
    }

    setState(() {
      _isBuying = false;
      _isAddingToUserCourses = false;
    });
  }

  void _myCourses() {
    print('Navigating to My Courses');
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => UserCourses()));
  }

  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser!;
    final addedCoursesProvider = Provider.of<AddedCoursesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Column(children: [
        Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('userCart')
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

                final addedCourses = addedcoursesSnapchots.data!.docs;

                return ListView.builder(
                    itemCount: addedCourses.length,
                    itemBuilder: (ctx, index) {
                      final addedCourse = addedCourses[index].data();
                      final courseId = addedCourse['courseId'];
                      final courseTitle = addedCourse['courseTitle'];
                      final courseDescription =
                          addedCourse['courseDescription'];
                      final courseVideo = addedCourse['courseVideo'];
                      final courseImage = addedCourse['courseImage'];
                      final cousreInstructor = addedCourse['cousreInstructor'];
                      final courseLanguage = addedCourse['courseLanguage'];
                      final courseHours = addedCourse['courseHours'];
                      final coursePriceString = addedCourse['coursePrice'];
                      final coursePrice =
                          double.tryParse(coursePriceString) ?? 0.0;

                      return Column(mainAxisSize: MainAxisSize.max, children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Card(
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 70,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              courseImage,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                courseId,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                courseTitle,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                cousreInstructor,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                'EGP $coursePrice',
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: TextButton(
                                          onPressed: () => _removeCourse(
                                                courseId,
                                                coursePrice,
                                                addedCoursesProvider,
                                              ),
                                          child: Text('remove')),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                            width: 320,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () => _buyNow(
                                courseId,
                                courseTitle,
                                courseDescription,
                                courseVideo,
                                courseImage,
                                cousreInstructor,
                                courseLanguage,
                                courseHours,
                                coursePrice,
                                addedCoursesProvider,
                              ),
                              child: Text('Buy Now'),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 16, 38, 56)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ]);
                    });
              }),
        ),
        Expanded(child: Container())
      ]),
    );
  }
}

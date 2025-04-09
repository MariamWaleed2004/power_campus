import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:power_campus/providers/add_remove_courses_provider.dart';
import 'package:power_campus/screens/course.dart';
// import 'package:provider/provider.dart';

class UserCourses extends StatefulWidget {
  const UserCourses({
    super.key,
  });

  @override
  State<UserCourses> createState() => _UserCoursesState();
}

class _UserCoursesState extends State<UserCourses> {
  void _coursePage(
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
  ) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => CourseScreen(
        courseId: courseId,
        courseTitle: courseTitle,
        courseDescription: courseDescription,
        courseVideo: courseVideo,
        courseImage: courseImage,
        cousreInstructor: cousreInstructor,
        courseLanguage: courseLanguage,
        courseHours: courseHours,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // final addedCoursesProvider = Provider.of<AddedCoursesProvider>(context);
    final User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 224, 224),
      body: Column(children: [
        Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('userCourses')
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
                        final cousreInstructor =
                            addedCourse['cousreInstructor'];
                        final courseLanguage = addedCourse['courseLanguage'];
                        final courseHours = addedCourse['courseHours'];
                        final coursePrice = addedCourse['coursePrice'];

                        return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => CourseScreen(
                                                  courseId: courseId,
                                                  courseTitle: courseTitle,
                                                  courseDescription:
                                                      courseDescription,
                                                  courseVideo: courseVideo,
                                                  courseImage: courseImage,
                                                  cousreInstructor:
                                                      cousreInstructor,
                                                  courseLanguage:
                                                      courseLanguage,
                                                  courseHours: courseHours,
                                                )));
                                  },
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                        ),
                                        child: Container(
                                          width: 65,
                                          height: 65,
                                          // decoration: BoxDecoration(
                                          //     border: Border.all(color: const Color.fromARGB(255, 16, 28, 54))),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              courseImage,
                                              fit: BoxFit.cover,
                                            ),
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  // child: Column(
                                  //   children: [
                                  //     Container(
                                  //       width: 300,
                                  //       height: 180,
                                  //       decoration: BoxDecoration(
                                  //           border: Border.all(
                                  //               color: const Color.fromARGB(
                                  //                   255, 16, 28, 54))),
                                  //       child: ClipRRect(
                                  //         //borderRadius: BorderRadius.circular(10),
                                  //         child: Image.network(
                                  //           courseImage,
                                  //           width: 150,
                                  //           height: 100,
                                  //           fit: BoxFit.cover,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     Align(
                                  //       alignment: Alignment.topLeft,
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.only(
                                  //             left: 30, top: 10),
                                  //         child: Text(
                                  //           courseId,
                                  //           style: const TextStyle(
                                  //             fontSize: 20,
                                  //             fontWeight: FontWeight.bold,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  // Align(
                                  //   alignment: Alignment.topLeft,
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.only(
                                  //         left: 30, top: 10),
                                  //     child: Text(
                                  //       courseTitle,
                                  //       style: const TextStyle(
                                  //         fontSize: 15,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // Align(
                                  //   alignment: Alignment.topLeft,
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.only(
                                  //         left: 30, top: 5),
                                  //     child: Text(
                                  //       cousreInstructor,
                                  //       style: const TextStyle(
                                  //         fontSize: 12,
                                  //         color: Colors.grey,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  //   ],
                                  // ),
                                ),
                              ),
                            ]);
                      });
                })),
        //  ElevatedButton(
        //   onPressed: () =>_courses(courseId),
        //    child: const Text('Add Course'),
        // ),
      ]),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _courses(courseId),
      //   backgroundColor: Color.fromARGB(255, 22, 39, 83),
      //   child: const Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

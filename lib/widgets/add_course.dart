import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddedCoursesProvider extends ChangeNotifier {
  List<String> _addedCourseIds = [];

  List<String> get addedCourseIds => _addedCourseIds;

  Future<void> loadAddedCourseIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _addedCourseIds = prefs.getStringList('addedCourseIds') ?? [];

    notifyListeners();
  }

  void addCourseId(String courseId) async {
    _addedCourseIds.add(courseId);
    notifyListeners();
    await _saveAddedCourseIds();
  }

  Future<void> _saveAddedCourseIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('addedCourseIds', _addedCourseIds);
  }

  void removeCourseId(String courseId) async {
    _addedCourseIds.remove(courseId);
    notifyListeners();
    await _saveAddedCourseIds();
  }
}

class AddCourse extends StatefulWidget {
  const AddCourse({super.key});

  @override
  State<AddCourse> createState() {
    return _AddCourseState();
  }
}

class _AddCourseState extends State<AddCourse> {
  List<Column> courseWidgets = [];

  var _isAdding = false;
  var isCourseAdded = false;

  @override
  void initState() {
    super.initState();
    Provider.of<AddedCoursesProvider>(context, listen: false)
        .loadAddedCourseIds();
  }

  void _addCourse(
    String courseId,
    String courseTitle,
    AddedCoursesProvider addedCoursesProvider,
  ) async {
    setState(() {
      _isAdding = true;
    });

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    addedCoursesProvider.addCourseId(courseId);

    final courseDocRef =
        FirebaseFirestore.instance.collection('Courses').doc(courseId);

    final subcollectionRef = courseDocRef.collection('addedBy');

    await subcollectionRef.add({
      'userId': user.uid,
      'username': userData.data()!['username'],
      'addedAt': Timestamp.now(),
    });

    setState(() {
      _isAdding = false;
      isCourseAdded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final addedCoursesProvider = Provider.of<AddedCoursesProvider>(context);

    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text('Available Cources'),
          backgroundColor: const Color.fromARGB(255, 3, 15, 32),
        ),
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('Courses').snapshots(),
            builder: (ctx, coursesSnapchots) {
              if (coursesSnapchots.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!coursesSnapchots.hasData ||
                  coursesSnapchots.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No courses found'),
                );
              }

              if (coursesSnapchots.hasError) {
                return const Center(
                  child: Text('Something went wrong...'),
                );
              }

              final courses = coursesSnapchots.data!.docs.toList();

              return ListView.builder(
                itemCount: courses.length,
                itemBuilder: (ctx, index) {
                  final course = courses[index];

                  final courseId = course['id'];
                  final isCourseAdded =
                      addedCoursesProvider.addedCourseIds.contains(courseId);

                  final user = FirebaseAuth.instance.currentUser;

                  final userId = user != null ? user.uid : null;

                  return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance
                        .collection('Courses')
                        .doc(courseId)
                        .collection('addedBy')
                        .where('userId', isEqualTo: userId)
                        .limit(1)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }

                      final courseAddedByCurrentUser =
                          snapshot.data!.docs.isNotEmpty;

                      return Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Card(
                          color: const Color.fromARGB(255, 216, 209, 209),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    course['id'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      course['title'],
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ),
                                  //if (_isAdding) const CircularProgressIndicator(),
                                  //if (!_isAdding)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: isCourseAdded &&
                                              courseAddedByCurrentUser
                                          ? null
                                          : () => _addCourse(
                                                course['id'],
                                                course['title'],
                                                addedCoursesProvider,
                                              ),
                                      child: isCourseAdded &&
                                              courseAddedByCurrentUser
                                          ? const Text('Course Added')
                                          : const Text('Add Course'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }));
  }
}

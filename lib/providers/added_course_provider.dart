import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddedCoursesNotifier extends StateNotifier<List<String>> {
  AddedCoursesNotifier() : super([]);

  void addCourse(String courseId) {
    state = [...state, courseId];
  }

  bool isCourseAdded(String courseId) {
    return state.contains(courseId);
  }
}

final addedCoursesProvider =
    StateNotifierProvider<AddedCoursesNotifier, List<String>>(
        (ref) => AddedCoursesNotifier());

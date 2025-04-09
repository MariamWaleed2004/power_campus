import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddedCoursesProvider extends ChangeNotifier {
  List<String> _addedCourseIds = [];
  final List<String> _purchasedCourseIds = [];
  double _totalPrice = 0.0;
  // List<String> _lastOpenedCourses = [];

  List<String> get addedCourseIds => _addedCourseIds;
  List<String> get purchasedCourseIds => _purchasedCourseIds;
  double get totalPrice => _totalPrice;
  // List<String> get lastOpenedCourses => _lastOpenedCourses;

  Future<void> loadAddedCourseIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _addedCourseIds = prefs.getStringList('addedCourseIds') ?? [];
  
    notifyListeners();
    ;
  }

  Future<void> addCourseId(String courseId) async {
    _addedCourseIds.add(courseId);
    //  _totalPrice += coursePrice; 
    await _saveAddedCourseIds();
    notifyListeners();
  }

  Future<void> _saveAddedCourseIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('addedCourseIds', _addedCourseIds);
  }

  Future<void> removeCourseId(String courseId) async {
    _addedCourseIds.remove(courseId);
    //_totalPrice -= coursePrice; // Update total price
    await _saveAddedCourseIds();
    notifyListeners();
  }

  void purchaseCourseId(String courseId) {
    if (!_purchasedCourseIds.contains(courseId)) {
      _purchasedCourseIds.add(courseId);
      notifyListeners();
    }
  }

  
}

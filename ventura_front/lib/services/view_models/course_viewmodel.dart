import 'package:flutter/material.dart';
import 'package:ventura_front/services/models/course_model.dart';
import 'package:ventura_front/mvvm_components/viewmodel.dart';
import 'package:ventura_front/services/repositories/courses_repository.dart';

class CourseViewModel extends EventViewModel {
  int _calificationIdCounter = 0;

  int get _generateCalificationId {
    return ++_calificationIdCounter;
  }

  TextEditingController _descriptionController = TextEditingController();

  Future<void> sendCourse(
      {required int userId, required int locationId}) async {
    final course = Course(
      id: _generateCalificationId,
      name: "Moviles",
      description: _descriptionController.text,
      date: 2,
      professor: "Mario Linares",
    );

    final repository = CoursesRepository();
    try {
      await repository.sendCourse(course);
    } catch (e) {
      throw Exception('Failed to send course');
    }
  }
  
}

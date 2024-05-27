import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ventura_front/services/models/course_model.dart';

class CoursesRepository {
  Future<void> sendCourse(Course course) async {
    final jsonData = course.toJson();

    final response = await http.post(
      Uri.parse('/api/user_courses/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(jsonData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send rating');
    }
  }
}

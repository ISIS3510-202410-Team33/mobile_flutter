import 'package:ventura_front/services/models/grade_model.dart';

class Course {
  final int id;
  final String name;
  final String teacher;
  final String schedule;
  final List<Grade> grades;

  Course({
    required this.id,
    required this.name,
    required this.teacher,
    required this.schedule,
    this.grades = const [],
  });

  Course copyWith({List<Grade>? grades}) {
    return Course(
      id: id,
      name: name,
      teacher: teacher,
      schedule: schedule,
      grades: grades ?? this.grades,
    );
  }
}
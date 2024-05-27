import 'package:ventura_front/services/models/grade_model.dart';

class Course {
  int id;
  String name;
  String description;
  int date;
  String professor;
  List<Grade> grades;



  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.professor,
    this.grades = const [],
  });


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date,
      'professor': professor,
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      date: json['date'],
      professor: json['professor'],
    );
  }

  copyWith({
    List<Grade>? grades,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      date: date ?? this.date,
      professor: professor ?? this.professor,
      grades: grades ?? this.grades,
    );
  }


}
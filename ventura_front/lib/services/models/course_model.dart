import 'package:ventura_front/services/models/grade_model.dart';

class Course {
  int? id;
  String name;
  String room;
  String schedule;
  String professor;
  List<Grade> grades;



  Course({
    this.id,
    required this.name,
    required this.room,
    required this.professor,
    required this.schedule,
    this.grades = const [],
  });


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'room': room,
      'professor': professor,
      'schedule': schedule,
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      room: json['room'],
      professor: json['professor'],
      schedule: json['schedule'],
    );
  }

  copyWith({
    int? id,
    String? name,
    String? room,
    String? professor,
    String? schedule,
    List<Grade>? grades,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      room: room ?? this.room,
      professor: professor ?? this.professor,
      schedule: schedule ?? this.schedule,
      grades: grades ?? this.grades,
    );
  }

}
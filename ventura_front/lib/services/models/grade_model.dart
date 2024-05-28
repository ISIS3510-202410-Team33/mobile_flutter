class Grade {
  int? id;
  final int courseId;
  final double grade;
  final String name;

  Grade({
    this.id,
    required this.courseId,
    required this.grade,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'grade': grade,
      'name': name,
    };
  }

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'],
      courseId: json['courseId'],
      grade: json['grade'],
      name: json['name'],
    );
  }
}
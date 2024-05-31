class Grade {
  int? id;
  final int courseId;
  final double grade;
  final double percentage;
  final String name;

  Grade({
    this.id,
    required this.courseId,
    required this.grade,
    required this.name,
    required this.percentage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'grade': grade,
      'name': name,
      'percentage': percentage,
    };
  }

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'],
      courseId: json['courseId'],
      grade: json['grade'],
      name: json['name'],
      percentage: json['percentage'],
    );
  }
}
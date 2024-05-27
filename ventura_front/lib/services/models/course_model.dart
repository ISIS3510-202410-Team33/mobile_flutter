
class Course {
  int id;
  String name;
  String description;
  int date;
  String professor;



  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.professor,
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


}
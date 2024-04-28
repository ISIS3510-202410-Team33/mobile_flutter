class Calification {
  int id;
  int calification;
  String description;
  String date;
  int user;
  int collegeLocation;

  Calification({
    required this.id,
    required this.calification,
    required this.description,
    required this.date,
    required this.user,
    required this.collegeLocation,
  });


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'calification': calification,
      'description': description,
      'date': date,
      'user': user,
      'college_location': collegeLocation,
    };
  }

}
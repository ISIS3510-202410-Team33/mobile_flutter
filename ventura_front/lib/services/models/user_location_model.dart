class UserLocationModel {
  int id;
  int frequency; 
  int user;
  int collegeLocation;

  UserLocationModel({required this.id, required this.frequency, required this.user, required this.collegeLocation});
  
  static UserLocationModel fromJson(body) {
    return UserLocationModel(
      id: body['id'],
      frequency: body['frequency'],
      user: body['user'],
      collegeLocation: body['college_location']
    );
  }
}
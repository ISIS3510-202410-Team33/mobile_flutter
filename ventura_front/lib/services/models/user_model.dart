class UserModel {
  int id;
  String name;
  String email;
  int college;
  
  UserModel({required this.id, required this.name, required this.email, required this.college});
 
  static UserModel fromJson(body){
    return UserModel(
      id: body['id'],
      name: body['name'],
      email: body['email'],
      college: body['college']
    );
  }
}
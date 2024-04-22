import 'package:firebase_auth/firebase_auth.dart';
import 'package:ventura_front/services/models/user_model.dart';
import '../singleton_base.dart';

final class UserRepository extends SingletonBase<UserModel>{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel activeUser = UserModel(name: "Default", studentCode: 0, uuid: 0);
  //Singleton Pattern
  static  UserRepository? _instance;
  UserRepository._internal() {
    UserModel userInitial = UserModel(name: "Default", studentCode: 0, uuid: 0);
    state = userInitial;
  }
  static UserRepository getState() {
    return _instance ??= UserRepository._internal();
  } 
  //Singleton Pattern


  Future<UserModel> signIn(String email, String password) async {
      // Crear instancia si no existe
      if (_instance == null) {
        _instance = UserRepository.getState();
        return _instance!.state;
      }
      // Si la lista de locations esta vacia, consultar a Firebase Storage
      else if(_instance!.state.name == "Default"){ //
      
        print("Firebase Sign in");
        try {
          UserCredential userCred = await _auth.signInWithEmailAndPassword(email: email, password: password);
          _instance!.setState(UserModel(name: userCred.user!.email!.split("@")[0] , studentCode: 0, uuid: 0));
            return _instance!.state;
        } catch (e) {
          return Future.error(e);
        }
      }
      else {
        print("Cache locations");
        return _instance!.state;
      }

  } 

  Future<UserModel> signUp(String email, String password) async {
    // Crear instancia si no existe
      if (_instance == null) {
        _instance = UserRepository.getState();
        return _instance!.state;
      }
      // Si la lista de locations esta vacia, consultar a Firebase Storage
      else if(_instance!.state.name == "Default"){ //
      
        print("Firebase Sign up");
        try {
          UserCredential userCred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
          _instance!.setState(UserModel(name: userCred.user!.email!.split("@")[0] , studentCode: 0, uuid: 0));
            return _instance!.state;
        } catch (e) {
          return Future.error(e);
        }
      }
      else {
        print("Cache locations");
        return _instance!.state;
      }

}

  Future<UserModel> getCredentials() async {
    if (_instance == null) {
        _instance = UserRepository.getState();
        return _instance!.state;
      }
      // Si la lista de locations esta vacia, consultar a Firebase Storage
      else if(_instance!.state.name == "Default"){ //
      
        print("Firebase Credentials");
        try {
          User? userCred = await _auth.currentUser;
          if (userCred == null){
            throw Error();
          }
          else {
            _instance!.setState(UserModel(name: userCred.email!.split("@")[0] , studentCode: 0, uuid: 0));
            return _instance!.state;
          }
        } catch (e) {
          return Future.error(e);
        }
      }
      else {
        print("Cache locations");
        return _instance!.state;
      }
  }
}
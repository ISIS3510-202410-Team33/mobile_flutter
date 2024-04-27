import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' ;


final class UserRepository {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String domain = "ventura-backend-jaj1.onrender.com"; 

  Future<Response> getUser(String email) {

    Map<String, String> queryParameters = {
      "email" : email,
    } ;
    Uri url =  Uri.https(domain, "/api/users/", queryParameters);
    return get(url);
  }

  Future<Response> createUser(String email){
    Map<String, String> body = {
      "name" : email.split("@")[0],
      "email" : email,
      "college" : "1",
    } ;
    Uri url =  Uri.https(domain, "/api/users/");
    return post(url, body: body);
  }
  
  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  } 

  Future<UserCredential> signUp(String email, String password) async {
    // Crear instancia si no existe
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() {
    return _auth.signOut();
  }

  User? getCredentials() {
    return _auth.currentUser;
  }
}
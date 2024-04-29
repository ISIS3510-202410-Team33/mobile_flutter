import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ventura_front/services/models/user_model.dart';
import 'package:ventura_front/services/repositories/user_repository.dart';

import '../../mvvm_components/viewmodel.dart';
import '../../mvvm_components/observer.dart';


class UserViewModel extends EventViewModel {

  late UserRepository _repository;
  static final UserViewModel _instance = UserViewModel._internal();
  UserModel user = UserModel(id: -1, name: "Default", email: "Default", college: -1);

  factory UserViewModel() {
    return _instance;
  }

  UserViewModel._internal() {
    print("New UserViewModel");
    _repository = UserRepository();
  }

  void getCredentials(){
    print("Looking for credentials");
    notify(LoadingUserEvent(isLoading: true));
    User? userCred = _repository.getCredentials();
    if (userCred != null) {
      _repository.getUser(userCred.email!).then((value) {
        final keys = jsonDecode(value.body);
        if (keys.length > 0) {
          UserModel userModel = UserModel.fromJson(keys[0]);
          user = userModel;
          notify(SignInSuccessEvent(user: userModel));
        }
        else{
          notify(SignInFailedEvent(reason: "backend-notFound"));
        }
      }).onError((error, stackTrace) {notify(SignInFailedEvent(reason: "backend-error"));});

      notify(LoadingUserEvent(isLoading: false));

    } else {
      notify(LoadingUserEvent(isLoading: false));
      notify(SignInFailedEvent(reason: "firebase-notLoggedIn"));
    }
    
  }

  void signIn(String email, String password) {
    notify(LoadingUserEvent(isLoading: true));
    _repository.signIn(email, password).then((value) {
      return _repository.getUser(email);
    })
    .then((value) {
      final decodejson = jsonDecode(value.body);
      if (decodejson.length == 0) {
        notify(SignInFailedEvent(reason: "backend-not-found"));
        notify(LoadingUserEvent(isLoading: false));
        return;
      }
      UserModel userModel = UserModel.fromJson(decodejson[0]);
      user = userModel;

      print("UserViewModel: signIn: ${user}");
      notify(SignInSuccessEvent(user: user));
      notify(LoadingUserEvent(isLoading: false));
    })
    .catchError((error){
      notify(SignInFailedEvent(reason: "Error ${error.toString()}"));
      notify(LoadingUserEvent(isLoading: false));
    });
  }

  void signOut() {
    notify(LoadingUserEvent(isLoading: true));
    _repository.signOut();
    notify(SignOutEvent(success: true));
    notify(LoadingUserEvent(isLoading: false));
  }

  void signUp(String email, String password) {
    notify(LoadingUserEvent(isLoading: true));
    _repository.signUp(email, password).then((value) {
      return _repository.createUser(email);
    })
    .then((value){
      if (value.statusCode == 201) {
        user = UserModel.fromJson(jsonDecode(value.body));
        notify(SignUpSuccessEvent(user: user));
        notify(LoadingUserEvent(isLoading: false));
      }
      else {
        notify(SignUpFailedEvent(reason: value.body));
        notify(LoadingUserEvent(isLoading: false));
      }
    })
    .catchError((error){
      notify(SignUpFailedEvent(reason: error.toString()));
      notify(LoadingUserEvent(isLoading: false));
    });
  }
}

class LoadingUserEvent extends ViewEvent {
  bool isLoading;
  LoadingUserEvent({required this.isLoading}) : super("LoadingUserEvent");
}

class SignInSuccessEvent extends ViewEvent {
  final UserModel user;

  SignInSuccessEvent({required this.user}) : super("SignInSuccessEvent");
}

class SignInFailedEvent extends ViewEvent {
  String reason;
  SignInFailedEvent({required this.reason}) : super("SignInFailedEvent");
}

class SignUpSuccessEvent extends ViewEvent {
  final UserModel user;

  SignUpSuccessEvent({required this.user}) : super("SignUpSuccessEvent");
}

class SignUpFailedEvent extends ViewEvent {
  String reason ;
  SignUpFailedEvent({required this.reason}) : super("SignUpFailedEvent");
}

class SignOutEvent extends ViewEvent {
  bool success;
  SignOutEvent({required this.success}) : super("SignOutEvent");
}

class FirebaseAuthFailedEvent extends ViewEvent {
  String message;
  FirebaseAuthFailedEvent({required this.message}) : super("FirebaseAuthFailedEvent");
}

class GetUserEvent extends ViewEvent {
  final bool success;

  GetUserEvent({required this.success}) : super("GetUserEvent");
}

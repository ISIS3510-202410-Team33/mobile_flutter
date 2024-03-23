import 'package:ventura_front/services/models/user_model.dart';
import 'package:ventura_front/services/repositories/user_repository.dart';

import '../../mvvm_components/viewmodel.dart';
import '../../mvvm_components/observer.dart';


class UserViewModel extends EventViewModel {

  final UserRepository _repository;
  UserViewModel(this._repository);

  void getCredentials(){
    notify(LoadingEvent(isLoading: true));
    _repository.getCredentials().then((value) {
      print("UserViewModel: signIn: ${value}");
      notify(SignInSuccessEvent(user: value));
      notify(LoadingEvent(isLoading: false));

    }).catchError((error){
      notify(SignInFailedEvent());
      notify(LoadingEvent(isLoading: false));
    });
  }

  void signIn(String username, String password) {
    notify(LoadingEvent(isLoading: true));
    _repository.signIn(username, password).then((value) {
      print("UserViewModel: signIn: ${value}");
      notify(SignInSuccessEvent(user: value));
      notify(LoadingEvent(isLoading: false));

    }).catchError((error){
      notify(SignInFailedEvent());
      notify(LoadingEvent(isLoading: false));
    });
  }

}

class LoadingEvent extends ViewEvent {
  bool isLoading;
  LoadingEvent({required this.isLoading}) : super("LoadingEvent");
}

class SignInSuccessEvent extends ViewEvent {
  final UserModel user;

  SignInSuccessEvent({required this.user}) : super("SignInSuccessEvent");
}

class SignInFailedEvent extends ViewEvent {

  SignInFailedEvent() : super("SignInFailedEvent");
}


import 'package:flutter/material.dart';
import 'package:ventura_front/mvvm_components/observer.dart';
import 'package:ventura_front/screens/login/view.dart';
import 'package:ventura_front/services/repositories/user_repository.dart';
import 'package:ventura_front/services/view_models/user_viewModel.dart';

class SignOutComponent extends StatefulWidget {
  const SignOutComponent({super.key});
  @override
  State<SignOutComponent> createState() => SignOutComponentState();
}

class SignOutComponentState extends State<SignOutComponent> implements EventObserver {

  static final UserViewModel _userViewModel = UserViewModel();

  @override
  void initState() {
    super.initState();
    _userViewModel.subscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: const LinearGradient(
              colors: [Color(0xFF1C1F22), Color(0xFF2F353A)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                _userViewModel.signOut();
              },
            )
          ],
        ));
  }

  @override
  void notify(ViewEvent event) {
    if (event is SignOutEvent && event.success) {
      print("SignOutComponent: SignOutEvent: success");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginView()));
    }
  }
}

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
    return 
    Material(
      elevation: 15,
      shadowColor: Colors.black,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              _userViewModel.signOut();
            },
          ),
          const Text("Sign Out", style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      )
        
      
    )
    ;
  }
  
  @override
  void notify(ViewEvent event) {
    if (event is SignOutEvent && event.success) {
      print("SignOutComponent: SignOutEvent: success");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginView())
      );
    }

  }

}
 
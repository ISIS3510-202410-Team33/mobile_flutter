import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ventura_front/screens/home/view.dart';
import 'package:ventura_front/screens/login/view.dart';

import "../../mvvm_components/observer.dart";
import "../../services/repositories/user_repository.dart";
import "../../services/view_models/user_viewmodel.dart";


class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => LoadingViewState ();
}

class LoadingViewState extends State<LoadingView> implements EventObserver{

  final UserViewModel _viewModel = UserViewModel(UserRepository.getState());
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _viewModel.subscribe(this);
    _viewModel.getCredentials();

  }

   @override
  void dispose() {
    super.dispose();
    _viewModel.unsubscribe(this);
  }

  @override
  void notify(ViewEvent event) {  

    if (event is LoadingEvent) {
      setState(() {
        _isLoading = event.isLoading;
      });
    } else if (event is SignInSuccessEvent) {

      print("Success");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeView(), // Reemplaza LoginView() con la pantalla siguiente
        ),
      );
    } else if (event is SignInFailedEvent) {
      print("No Credentials");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginView(), // Reemplaza LoginView() con la pantalla siguiente
        ),
      );
    }

  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white, // Fondo blanco
    body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 100),
        const Text(
          'VENTURA ©',
          style: TextStyle(
            fontSize: 40, 
            fontFamily: 'Lato', 
            color: Colors.black, 
          ),
        ),
        const SizedBox(height: 16),
        const Stack(
          alignment: Alignment.center,
          children: [
            LinearProgressIndicator(), 
          ],
        ),
        const SizedBox(height: 45),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 80), 
            child: Image.asset(
              'lib/icons/goose_icon.png', 
              width: 700, 
              height: 700, 
            ),
          ),
        ),
      ],
    ),
  );
}
}

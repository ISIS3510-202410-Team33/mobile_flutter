import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ventura_front/screens/home/view.dart';
import 'package:ventura_front/screens/login/view.dart';
import 'package:ventura_front/services/view_models/user_viewModel.dart';

import "../../mvvm_components/observer.dart";


class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => LoadingViewState ();
}

class LoadingViewState extends State<LoadingView> implements EventObserver{

  static final UserViewModel _viewModel = UserViewModel();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () {
      _viewModel.subscribe(this);
      _viewModel.getCredentials();

    });

    }

   @override
  void dispose() {
    super.dispose();
    _viewModel.unsubscribe(this);
  }

  @override
  void notify(ViewEvent event) {  

    if (event is LoadingUserEvent) {
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(height: 50),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text(
          'VENTURA',
          style: TextStyle(
            fontSize: 50, 
            fontFamily: 'Lato', 
            color: Colors.black, 
            fontWeight: FontWeight.w200,
          ),
          ),Text(
            '©',
            style: TextStyle(
              fontSize: 20, 
              fontFamily: 'Lato', 
              color: Colors.black, 
              fontWeight: FontWeight.w200,
            ),
          ),
        ],),
        const SizedBox(height: 16),
        const Stack(
          alignment: Alignment.center,
          children: [
            LinearProgressIndicator(), 
          ],
        ),
        const SizedBox(height: 45),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.7,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('lib/icons/goose-complete.png'),
              fit: BoxFit.fitHeight,
              alignment: Alignment.bottomCenter,
            ),
          ),)
      ],
    ),
  );
}
}

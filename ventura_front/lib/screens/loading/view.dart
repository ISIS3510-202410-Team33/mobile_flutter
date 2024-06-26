import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ventura_front/screens/home/view.dart';
import 'package:ventura_front/screens/login/view.dart';
import 'package:ventura_front/sensors_components/proximity_sensor.dart';
import 'package:ventura_front/services/view_models/connection_viewmodel.dart';
import 'package:ventura_front/services/view_models/user_viewModel.dart';

import "../../mvvm_components/observer.dart";
import "./components/no_connection_screen.dart";


class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => LoadingViewState ();
}

class LoadingViewState extends State<LoadingView> implements EventObserver{

  static final UserViewModel _userViewModel = UserViewModel();
  static final ConnectionViewModel _connectionViewModel = ConnectionViewModel();

  @override
  void initState() {
    super.initState();
    _userViewModel.subscribe(this);
    _connectionViewModel.subscribe(this);
    _connectionViewModel.isInternetConnected().then((value) {
      if (value){
        _userViewModel.getCredentials();
      }
    });
  }

  @override
  void dispose() {
    _userViewModel.unsubscribe(this);
    _connectionViewModel.unsubscribe(this);
    super.dispose();
  }

  @override
  void notify(ViewEvent event) {  
    if (event is SignInSuccessEvent) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeView(), // Reemplaza LoginView() con la pantalla siguiente
        ),
      );
    } 
    else if (event is SignInFailedEvent) {
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginView(), // Reemplaza LoginView() con la pantalla siguiente
        ),
      );
    }
    
    else if (event is ConnectionEvent) {
      print("Connection state: ${event.connection ? 'Connected' : 'Disconnected'}");
      if (event.connection) {
        if (_userViewModel.isSuscribed(this)){
          _userViewModel.getCredentials();
        }
        else {
          _userViewModel.subscribe(this);
          _userViewModel.getCredentials();
        }
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoadingNoConnectionView(), // Reemplaza LoginView() con la pantalla siguiente
          ),
        );
      }
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

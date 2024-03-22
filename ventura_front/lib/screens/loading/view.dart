import 'dart:async';
import 'package:flutter/material.dart';
import '/screens/login/view.dart'; // Importa la pantalla siguiente

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => LoadingViewState();
}

class LoadingViewState extends State<LoadingView> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginView(), // Reemplaza LoginView() con la pantalla siguiente
        ),
      );
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white, // Fondo blanco
    body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 100),
        Text(
          'VENTURA ©',
          style: TextStyle(
            fontSize: 40, 
            fontFamily: 'Lato', 
            color: Colors.black, 
          ),
        ),
        SizedBox(height: 16),
        Stack(
          alignment: Alignment.center,
          children: [
            LinearProgressIndicator(), 
          ],
        ),
        SizedBox(height: 45),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 80), 
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

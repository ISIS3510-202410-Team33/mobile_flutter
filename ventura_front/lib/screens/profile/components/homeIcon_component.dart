import 'package:flutter/material.dart';
import 'package:ventura_front/screens/home/view.dart';

class HomeIcon extends StatefulWidget {
  const HomeIcon({super.key});

  @override
  State<HomeIcon> createState() => HomeIconState();
}

class HomeIconState extends State<HomeIcon> {
  @override
  Widget build(BuildContext context){
      return Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: const LinearGradient(
                colors: [Color(0xFF1C1F22), Color(0xFF2F353A)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              )
            ), 
            child: IconButton(
              icon: const Icon(Icons.home_filled, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeView())
                );
              },
            ),
          );
    }
  }

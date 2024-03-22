import 'package:flutter/material.dart';

class University extends StatefulWidget {
  const University({super.key});

  @override
  State<University> createState() => UniversityState();
}

class UniversityState extends State<University> {
  @override
  Widget build(BuildContext context) {
    return 
    Material(
      elevation: 15,
      shadowColor: Colors.black,
      borderRadius: BorderRadius.circular(60),
      child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xFFFF891C),
          Color(0xFFFAFF00),
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topCenter,

        ),
        borderRadius: BorderRadius.all(Radius.circular(60)),
      ),
      child: const Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 50),
        child: Text("Universidad de los Andes", style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),),
        )
    ),
    )
    ;
  }
} 
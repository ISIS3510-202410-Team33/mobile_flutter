import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class University extends StatelessWidget {
  const University({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 15,
      shadowColor: Colors.black,
      borderRadius: BorderRadius.circular(60),
      child: InkWell(
        onTap: () {
          _launchURL();
        },
        borderRadius: BorderRadius.circular(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFF891C),
                Color(0xFFFAFF00),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.all(Radius.circular(60)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 50),
            child: Text(
              "Universidad de los Andes",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    const url = 'https://uniandes.edu.co/'; 
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}


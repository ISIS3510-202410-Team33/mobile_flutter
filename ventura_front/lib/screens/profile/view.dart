import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

import "../../services/models/profile_model.dart";
import '../home/components/university_component.dart';
import 'components/homeIcon_component.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {

  final ProfileModel user = ProfileModel(
    uuid: 1, 
    name: "Manuela Cruz",
    edad: 27,
    descripcion: "software engineering student 7th semester",
    imageUrl: "lib/icons/user_icon.png");

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Color(0xFFFDF21C), 
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Image.asset('lib/icons/uniandes_icon.png'), 
      ),
        actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: HomeIcon(), 
        )
        ]
    ), 
      backgroundColor: Color(0xFFFDF21C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2), 
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage(user.imageUrl),
                  ),
                ),
                SizedBox(height: 10), 
                Text(
                  '${user.name}, ${user.edad}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ABeZee'
                  ),
                ),
                    SizedBox(height: 20), 
            Container(
                width: 310, 
                height: 420, 
                decoration: BoxDecoration(
                  color: Color(0xFFF9FFF6), 
                  borderRadius: BorderRadius.circular(10), 
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    University(),
                    SizedBox(height: 20),
                    Text(
                      'Bogotá DC, Colombia',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Lato',
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '${user.descripcion}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Lato',
                      ),
                    ),
                    SizedBox(height: 20),
                    Image.asset('lib/icons/logo_icon.png', width: 180, height: 180),
                    SizedBox(height: 20),
                    Text(
                      '© Ventura',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 166, 165, 165),
                        fontSize: 15,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}
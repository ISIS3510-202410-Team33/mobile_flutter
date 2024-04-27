import "package:flutter/material.dart";
import "package:ventura_front/services/models/user_model.dart";
import "package:ventura_front/services/view_models/user_viewModel.dart";

import '../home/components/university_component.dart';
import 'components/homeIcon_component.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {


  final UserModel _user = UserViewModel().user;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: const Color(0xFFFDF21C), 
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Image.asset('lib/icons/uniandes_icon.png'), 
      ),
        actions: const [
        Padding(
          padding: EdgeInsets.only(right: 14),
          child: HomeIcon(), 
        )
        ]
    ), 
      backgroundColor: const Color(0xFFFDF21C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2), 
                  ),
                  child: const CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('lib/icons/perfil-de-usuario.png'),
                  ),
                ),
                const SizedBox(height: 10), 
                Text(
                  '${_user.name} ',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ABeZee'
                  ),
                ),
                    const SizedBox(height: 20), 
            Container(
                width: 310, 
                height: 420, 
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FFF6), 
                  borderRadius: BorderRadius.circular(10), 
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const University(),
                    const SizedBox(height: 20),
                    const Text(
                      'Bogotá DC, Colombia',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Lato',
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Additional Information',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Lato',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset('lib/icons/logo_icon.png', width: 180, height: 180),
                    const SizedBox(height: 20),
                    const Text(
                      '© Ventura',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 166, 165, 165),
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
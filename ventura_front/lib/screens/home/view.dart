import 'package:flutter/material.dart';
import 'package:ventura_front/services/repositories/user_repository.dart';
import '../components/header_component.dart';
import './components/weather_component.dart';
import './components/university_component.dart';
import './components/options_component.dart';

import '../../services/models/user_model.dart';
import '../../services/models/weather_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => HomeViewState();
}


class HomeViewState extends State<HomeView> {

  double time = 0.0;
  double distance = 0.0;

  UserModel user = UserModel(
    uuid: 0, 
    name: "Default",
    studentCode: 0);

  final UserModel _user = UserRepository.getState().state;
  


  final WeatherModel weather = WeatherModel(
    location: "Bogotá, Colombia",
    description: "Cloudy",
    temperature: 24,
    feelsLike: "28°",
    presure: 1000.0,
    humidity: 0.65
  );

  

  @override
  void initState()  {
    super.initState();
    user = _user;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF16171B), Color(0xFF353A40)],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft)),
        child:  Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
              padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //header of the app
                children: [
                  Header(showUserInfo: true, user: user, showHomeIcon: false),
                  const SizedBox(height: 20),
                  Weather(weather: weather),
                  const SizedBox(height: 20),
                  const University(),
                  const SizedBox(height: 20),
                  const Options(),
                ],
              )),
        ));
  }
}

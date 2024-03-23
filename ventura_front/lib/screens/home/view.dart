import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ventura_front/screens/home/components/weather_fetch.dart';
import 'package:ventura_front/services/repositories/user_repository.dart';
import 'package:ventura_front/services/repositories/user_repository.dart';
import 'package:ventura_front/services/view_models/weather_viewmodel.dart';
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
  Position? position;

  Future<Position> determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    try {
      position = await determinePosition();
      print(position!.latitude);
      print(position!.longitude);
    } catch (e) {
      print(e);
    }
  }

  UserModel user = UserModel(uuid: 0, name: "Default", studentCode: 0);

  final UserModel _user = UserRepository.getState().state;

  

  @override
  void initState() {
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
              padding: const EdgeInsets.only(
                  top: 40, left: 20, right: 20, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Header(showUserInfo: true, user: user, showHomeIcon: false),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  Consumer<WeatherViewModel>(
                    builder: (context, viewModel, child) {
                      return FutureBuilder<WeatherModel>(
                        future: viewModel.getWeather(
                            position!.latitude, position!.longitude),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            return Weather(weather: snapshot.data!);
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const University(),
                  const SizedBox(height: 20),
                  const Options(),
                ],
              )),
        ));
  }
}

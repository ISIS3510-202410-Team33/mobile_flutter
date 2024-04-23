import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:ventura_front/services/repositories/user_repository.dart';
import 'package:ventura_front/services/view_models/weather_viewmodel.dart';
import '../components/header_component.dart';
import './components/weather_component.dart';
import './components/university_component.dart';
import './components/options_component.dart';

import '../../services/models/user_model.dart';
import '../../services/models/weather_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherViewModel(),
      child: HomeViewContent(),
    );
  }
}

class HomeViewContent extends StatefulWidget {
  @override
  State<HomeViewContent> createState() => HomeViewContentState();
}

class HomeViewContentState extends State<HomeViewContent> {
  Position? position;
  late WeatherViewModel weatherViewModel;

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

  Future<void> getCurrentLocation() async {
    try {
      position = await determinePosition();
      weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
      await weatherViewModel.getWeather(
          position!.latitude, position!.longitude);
    } catch (e) {
      print(e);
    }
  }

  UserModel user = UserModel(uuid: 0, name: "Default", studentCode: 0);

  final UserModel _user = UserRepository.getState().state;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    user = _user;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF16171B), Color(0xFF353A40)],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.only(
            top: 40,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Header(
                showUserInfo: true,
                user: user,
                showHomeIcon: false,
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              Consumer<WeatherViewModel>(
                builder: (context, weatherViewModel, _) {
                  final weatherData = weatherViewModel.weatherData;
                  if (weatherData != null) {
                    return Weather(
                      weather: weatherData,
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              const SizedBox(height: 20),
              const University(),
              const SizedBox(height: 10),
              const Options(),
            ],
          ),
        ),
      ),
    );
  }
}

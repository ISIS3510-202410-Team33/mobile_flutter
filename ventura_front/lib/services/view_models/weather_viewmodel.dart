import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import '../repositories/weather_repository.dart';

class WeatherViewModel extends ChangeNotifier {
  WeatherModel? weatherData;
  final WeatherRepository _weatherRepository = WeatherRepository();

  Future<void> getWeather(double lat, double lon) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? weatherR = prefs.getString('weather');
    if (weatherR != null) {
      weatherData = WeatherModel.comingJson(json.decode(weatherR));
      notifyListeners();
    } else {
      try {
        weatherData = await _weatherRepository.fetchWeather(lat, lon);
        prefs.setString('weather', jsonEncode(weatherData!.toJson()));
        notifyListeners();
      } catch (e) {
        print('Error fetching weather: $e');
      }
    }
  }
}

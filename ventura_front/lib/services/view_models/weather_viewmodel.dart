import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../repositories/weather_repository.dart';

class WeatherViewModel extends ChangeNotifier {
  WeatherModel? weatherData;
  final WeatherRepository _weatherRepository = WeatherRepository();

  Future<void> getWeather(double lat, double lon) async {
    try {
      weatherData = await _weatherRepository.fetchWeather(lat, lon);
      notifyListeners();
    } catch (e) {
      print('Error fetching weather: $e');
    }
  }
}

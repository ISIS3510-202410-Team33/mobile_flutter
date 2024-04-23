import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather_model.dart';

class WeatherRepository {
  Future<WeatherModel> fetchWeather(double lat, double lon) async {
    final apiKey = '668c50fd98cdfe606ab0440ee65979c3';
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

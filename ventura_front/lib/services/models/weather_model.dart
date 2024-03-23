import 'dart:ffi';

class WeatherModel {
  String description;
  String location;
  double temperature;
  double feelsLike;
  double pressure;
  double humidity;

  WeatherModel({
    required this.description,
    required this.location,
    required this.temperature,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      description: json['weather'][0]['description'],
      location: json['name'],
      temperature: (json['main']['temp'] - 273.15),
      feelsLike: (json['main']['feels_like'] - 273.15),
      pressure: json['main']['pressure'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
    );
  }
}

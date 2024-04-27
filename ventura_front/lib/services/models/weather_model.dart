class WeatherModel {
  String description;
  String location;
  double temperature;
  double feelsLike;
  double pressure;
  double humidity;
  bool signal;

  WeatherModel(
      {required this.description,
      required this.location,
      required this.temperature,
      required this.feelsLike,
      required this.pressure,
      required this.humidity,
      required this.signal});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
        description: json['weather'][0]['description'],
        location: json['name'],
        temperature: (json['main']['temp'] - 273.15),
        feelsLike: (json['main']['feels_like'] - 273.15),
        pressure: json['main']['pressure'].toDouble(),
        humidity: json['main']['humidity'].toDouble(),
        signal: true);
  }
}

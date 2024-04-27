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

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'location': location,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'pressure': pressure,
      'humidity': humidity,
      'signal': signal,
    };
  }

  factory WeatherModel.comingJson(Map<String, dynamic> json) {
    return WeatherModel(
      description: json['description'],
      location: json['location'],
      temperature: json['temperature'],
      feelsLike: json['feelsLike'],
      pressure: json['pressure'],
      humidity: json['humidity'],
      signal: json['signal'],
    );
  }

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

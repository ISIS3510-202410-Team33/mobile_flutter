class WeatherModel {

  String description;
  String location;
  double temperature;
  String feelsLike;
  double presure;
  double humidity;

  WeatherModel(
      {required this.description,
       required this.location,
      required this.temperature,
       required this.feelsLike,
       required this.presure,
       required this.humidity});
}
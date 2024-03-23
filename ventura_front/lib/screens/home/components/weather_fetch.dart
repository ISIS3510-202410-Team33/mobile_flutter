import 'package:flutter/material.dart';
import 'package:ventura_front/screens/home/components/weather_component.dart';
import 'package:ventura_front/services/models/weather_model.dart';

class WeatherFetch extends StatelessWidget {
  final Future<WeatherModel> weather;

  WeatherFetch({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<WeatherModel>(
          future: weather,
          builder: (context, snapshot) => snapshot.hasData
              ? Weather(weather: snapshot.data!)
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

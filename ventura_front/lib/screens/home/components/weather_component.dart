import 'package:flutter/material.dart';
import '../../../services/models/weather_model.dart';

class Weather extends StatelessWidget {
  final WeatherModel weather;
  const Weather({super.key, required this.weather});

  String firstLetterUppercase(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2C2F36),
          borderRadius: BorderRadius.all(Radius.circular(60)),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.cloud, color: Colors.white, size: 30),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(firstLetterUppercase(weather.description),
                              style:
                                  const TextStyle(color: Colors.white, fontSize: 16)),
                          Text(weather.location,
                              style:
                                  const TextStyle(color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                  Text("${(weather.temperature).toStringAsFixed(2)}°",
                      style: const TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${(weather.feelsLike).toStringAsFixed(2)}°",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14)),
                      const Text("Sensible",
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(" ${(weather.humidity).round()}%",
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                      const Text("Humidity",
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${weather.pressure} hps",
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                      const Text("Pressure",
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }
}

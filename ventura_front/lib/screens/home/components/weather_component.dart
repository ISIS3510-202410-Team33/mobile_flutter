import 'package:flutter/material.dart';
import 'package:ventura_front/services/view_models/connection_viewmodel.dart';
import '../../../services/models/weather_model.dart';

class Weather extends StatelessWidget {
  final WeatherModel? weather;
  const Weather({super.key, required this.weather});

  Weather.noSignal() : weather = null;

  

  String firstLetterUppercase(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  LinearGradient getBackgroundGradient() {
    if (!weather!.signal) {
      return const LinearGradient(
        colors: [Color(0x1BFFFFFF), Color(0x1BFFFFFF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (weather!.description.contains('rain')) {
      return const LinearGradient(
        colors: [Color(0x1BFFFFFF), Color(0x4D90CAF9)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (weather!.description.contains('cloud')) {
      return const LinearGradient(
        colors: [Color(0x1BFFFFFF), Color(0x1BFFFFFF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (weather!.description.contains('clear')) {
      return const LinearGradient(
        colors: [Color(0x1BFFFFFF), Color(0x4DFBB81C)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [Color(0x1BFFFFFF), Color(0x1BFFFFFF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!weather!.signal ) {
      return Container(
          decoration: BoxDecoration(
            gradient: getBackgroundGradient(),
            borderRadius: BorderRadius.all(Radius.circular(60)),
          ),
          child: Padding(
              padding: const EdgeInsets.only(
                  top: 30, bottom: 10, left: 20, right: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(children: [
                            Image.asset('lib/icons/error.png',
                                width: 30, height: 30),
                            const SizedBox(
                              width: 20,
                            ),
                            const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'No internet connection,',
                                    softWrap: true,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'cannot fetch weather info',
                                    softWrap: true,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ])
                          ])
                        ])
                  ])));
    } else {
      return Container(
          decoration: BoxDecoration(
            gradient: getBackgroundGradient(),
            borderRadius: BorderRadius.all(Radius.circular(60)),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 30, bottom: 10, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        if (weather!.description.contains('rain'))
                          Image.asset('lib/icons/rain.png',
                              width: 30, height: 30)
                        else if (weather!.description.contains('cloud'))
                          Image.asset('lib/icons/cloud.png',
                              width: 30, height: 30)
                        else if (weather!.description.contains('clear'))
                          Image.asset('lib/icons/clear.png',
                              width: 30, height: 30)
                        else
                          Image.asset('lib/icons/cloud.png',
                              width: 30, height: 30),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(firstLetterUppercase(weather!.description),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16)),
                            Text(weather!.location,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                    Text("${(weather!.temperature).toStringAsFixed(2)}°",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${(weather!.feelsLike).toStringAsFixed(2)}°",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14)),
                        const Text("Sensible",
                            style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(" ${(weather!.humidity).round()}%",
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        const Text("Humidity",
                            style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${weather!.pressure} hps",
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        const Text("Pressure",
                            style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  if (weather!.description.contains("rain") ||
                      weather!.description.contains("drizzle"))
                    const Text("Watch out! It's raining heavily.",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))
                  else
                    const Text("Weather seems fine today!",
                        style: TextStyle(color: Colors.white, fontSize: 18))
                ])
              ],
            ),
          ));
    }
  }
}

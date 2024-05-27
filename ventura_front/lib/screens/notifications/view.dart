import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ventura_front/mvvm_components/observer.dart';
import 'package:ventura_front/services/models/location_model.dart';
import 'package:ventura_front/services/view_models/connection_viewmodel.dart';
import 'package:ventura_front/services/view_models/locations_viewmodel.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView>  implements EventObserver{
  bool _hasConnection = true;
  final LocationsViewModel _viewModel = LocationsViewModel();
  String? _recommendedLocationName;

  void _findRecommendedLocation() {
    if (_viewModel.recommendedList.isNotEmpty) {
      print("Recommended list: ${_viewModel.recommendedList}");
      String firstLocation = _viewModel.recommendedList.first;
      LocationModel? firstLocationModel = _viewModel.locations[firstLocation];
      setState(() {
        if (firstLocationModel != null){
          _recommendedLocationName = firstLocationModel.name;
        } 
      });
    }
  }

  void _launchURL() async {
    if (_recommendedLocationName != null) {
      final url = Uri.https('campusinfo.uniandes.edu.co', "/es/recursos/edificios/bloqueml/");
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } 
  }

  @override
  void initState() {
    super.initState();
    _viewModel.getLocationsCache(); 
    _findRecommendedLocation();
  }

  @override
  void notify(ViewEvent event) {
    if (event is ConnectionEvent) {
      setState(() {
        _hasConnection = event.connection;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 46, 45, 45), // Fondo gris
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white, // Fondo blanco
                borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 160, 159, 159).withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // Cambia la posición de la sombra
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: _hasConnection ? () {
                  _launchURL();
                } : null, // Desactiva el onTap si no hay conexión
                child: Text(
                  "Your most recommended location is: $_recommendedLocationName",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _findRecommendedLocation() {
    if (_viewModel.locations.isNotEmpty) {
      var firstLocation = _viewModel.locations.values.first;
      setState(() {
        _recommendedLocationName = firstLocation.name;
      });
    }
  }

  void _launchURL() async {
    if (_recommendedLocationName != null && _recommendedLocationName!.toLowerCase().contains('ml')) {
      final url = Uri.https('campusinfo.uniandes.edu.co', "/es/recursos/edificios/bloqueml/");
      if (await canLaunch(url.toString())) {
        await launch(url.toString());
      } else {
        throw 'Could not launch $url';
      }
    } else {
      print('Location not supported');
    }
  }
}
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_launcher/map_launcher.dart';
import '../singleton_base.dart';

final class GpsRepository extends SingletonBase<Position>{


  //Singleton Pattern
  static  GpsRepository? _instance;
  
  GpsRepository._internal()  {
    Position positionInitial = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 0, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy: 0, speed: 0, speedAccuracy: 0) ;
    state = positionInitial;
  }
  static GpsRepository getState() {
    return _instance ??= GpsRepository._internal();
  } 
  //Singleton Pattern

  // Conection with Firebase Storage


  Future<Position> determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
      if(permission == LocationPermission.deniedForever){
        return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      }
    }
    Position position = await Geolocator.getCurrentPosition(); 
    setState(position);
    return position;
  }

  Position getCurrentLocation()  {
    return state;
  }

  double getDistance(Position location) {
    return Geolocator.distanceBetween(state.latitude, state.longitude, location.latitude, location.longitude);
  }

  // Returns time in seconds - Default speed is 5 km/h - 1.38889 m/s
  double getTime(Position location) {
    return Geolocator.distanceBetween(state.latitude, state.longitude, location.latitude, location.longitude) / 1.38889;
  }

  double getDistanceLatLon(double latitude, double longitude) {
    return Geolocator.distanceBetween(state.latitude, state.longitude, latitude, longitude);
  }

  // Returns time in seconds - Default speed is 5 km/h - 1.38889 m/s 
  // Type 0 = Walking, 1 = Cycling, 2 = Driving
  double getTimeLatLon(double latitude, double longitude, int type) {

    // Speed in m/s
    double walkingSpeed = (5 * 1000) / 3600; 
    double cyclingSpeed = (3 * 1000) / 3600;
    double drivingSpeed = (2 * 1000) / 3600;
    if (type == 0) {
      return Geolocator.distanceBetween(state.latitude, state.longitude, latitude,longitude) / walkingSpeed ;
    } else if (type == 1) {
      return Geolocator.distanceBetween(state.latitude, state.longitude, latitude,longitude) / cyclingSpeed ;
    } else {
      return Geolocator.distanceBetween(state.latitude, state.longitude, latitude,longitude) / drivingSpeed ;
    }
  }

  void launchGoogleMaps(double destinationLatitude, double destinationLongitude) async {
    print("Opening Google Maps");
    final availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showDirections(
      destination: Coords(destinationLatitude, destinationLongitude),
      destinationTitle: "Destination",
    );
  }

}


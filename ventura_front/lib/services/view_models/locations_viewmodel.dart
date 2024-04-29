import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/services.dart' show RootIsolateToken, rootBundle;
import 'package:ventura_front/services/repositories/gps_repository.dart';
import '../../mvvm_components/viewmodel.dart';
import '../../mvvm_components/observer.dart';

import '../repositories/locations_repository.dart';
import '../models/location_model.dart';
import '../models/user_location_model.dart';


class LocationsViewModel extends EventViewModel {
  
  static final LocationsViewModel _instance = LocationsViewModel._internal();
  List<String> recommendedList = [];
  String bestRated = "";
  late LocationRepository _repository;
  factory LocationsViewModel() => _instance;
  Map<String, LocationModel> locations = {};
  Map<String, LocationModel> locationsBase = {};

  int updatings = 0;

  LocationsViewModel._internal(){
    _repository = LocationRepository();
    _loadCacheInfo();
  
  }

  String getSite(String type){
    Map<String, LocationModel> locationsCopy = locations;
    Map<String, double> distances = {};

    GpsRepository gps = GpsRepository.getState();

    for (var key in locationsCopy.keys) {
      LocationModel location = locationsCopy[key]!;
      double distance = gps.getDistanceLatLon(location.latitude, location.longitude);
      distances.putIfAbsent(key, () => distance);
    }

    List<String> sortedIndices = getSortedIndex(distances);
    print(sortedIndices.toString());

    for (var key in sortedIndices) {
      LocationModel location = locationsCopy[key]!;
      if (type == "green_areas" && location.greenAreas > 0){
        return location.id.toString();
      }
      else if (type == "restaurant" && location.restaurants > 0){
        return location.id.toString();
      }
    }
    
    return distances.entries.first.key;
    
  }

  List<String> getSortedIndex(Map<String, double> distances){
    List<MapEntry<String, double>> entries = distances.entries.toList();
    entries.sort((a, b) => a.value.compareTo(b.value));
    List<String> sortedIndices = entries.map((entry) => entry.key).toList();
    return sortedIndices;
  }
  

  void getLocations(){
    notify(LoadingEvent(isLoading: true));
    if (locations.isEmpty) {
      getLocationsCache();
    }
    else {
      notify(LocationsLoadedEvent(success: true));
      notify(LoadingEvent(isLoading: false));

    }

  }

  void getLocationsCache(){
    rootBundle.loadString('lib/data/initial-locations.json').then((value) {
        final decodejson = jsonDecode(value);
        for (var key in decodejson) {
          final location = LocationModel(
            id: key['id'],
            name: key['name'],
            floors: key['floors'],
            greenAreas: key['green_zones'],
            restaurants: key['restaurants'],
            obstructions: key['obstructions'],
            latitude: key['latitude'],
            longitude: key['longitude']
            );
          locations.putIfAbsent(key['id'].toString(), () => location);
        };
        locationsBase = locations;
        notify(LoadingEvent(isLoading: false));
        notify(LocationsLoadedEvent( success: true));
      }).catchError((error){
        notify(LoadingEvent(isLoading: false));
        notify(LocationsLoadedEvent(success: false));
      });
  }

  void updateLocationFrequency(userId, locationId ) {

    _repository.updateLocationFrequency(userId, locationId).then(
      (value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          notify(LocationFrequencyUpdateEvent(success: true));
        }
        else {
          notify(LocationFrequencyUpdateEvent(success: false));
        }
      }
    // ignore: invalid_return_type_for_catch_error
    ).catchError((error) {
      print(error.toString());
      notify(LocationFrequencyUpdateEvent(success: false));
      return null;
    });
  }

  String getBestRatedLocation(){
    return bestRated;
  }

  void updateBestRatedLocation(){
    _repository.getBestRatedLocationsNet().then((value) {
      final decodejson = jsonDecode(value.body);
      if (decodejson.length > 0) {  
        bestRated = decodejson[0]['id'].toString();
        LocationModel locationBestRated = locations[bestRated]!;
        locationBestRated.bestRated = true;
        locations.update(bestRated, (value) => locationBestRated);
        _repository.saveBestRatedLocationCache(bestRated).then((value) {
          if (value ){
            print("Mejor valorado guardado en cache");
          }
          else{
            print("Error guardando mejor valorado en cache");
          }
        });
        notify(UpdateBestRatedLocationsEvent(success: true));
      }
      else{
        notify(UpdateBestRatedLocationsEvent(success: false));
      }
    }).catchError((error){
      notify(UpdateBestRatedLocationsEvent( success: false));
    });
  }

  void updateRecommendedLocationsCache() async{
    print("Actualizando recomendados desde cache");
    if (recommendedList.isNotEmpty && updatings == 0){
      locations = locationsBase;
      for (var locationId in recommendedList) {
        final location = locations[locationId];
        if (location != null){
          location.recommended = true;
          locations.update(location.id.toString(), (value) => location);
        }
      }
      notify(UpdateRecommendedLocationsEvent(success: true, recommendedList: recommendedList));
    }
  }

  void updateRecommendedLocationsNet(userId) async{
    print("Actualizando recomendados desde internet");
    _repository.getRecommendedLocationsNet(userId).then((value) {
        final decodejson = jsonDecode(value.body);
        print(decodejson);
        if (decodejson.length > 0) {  
          locations = locationsBase;

          for (var key in decodejson) {
            final location = locations[key['id'].toString()];
            recommendedList.add(key['id'].toString());
            if (location != null){
              location.recommended = true;
              locations.update(location.id.toString(), (value) => location);
            }
          }
          recommendedList = recommendedList.toSet().toList();
        }
        _repository.saveRecommendedLocationsCache(recommendedList).then((value) {
          if (value ){
            print("Recomendados guardados en cache");
          }
          else{
            print("Error guardando recomendados en cache");
          }
        });   
        notify(UpdateRecommendedLocationsEvent(success: true, recommendedList: recommendedList));
      }).catchError((error){
        notify(UpdateRecommendedLocationsEvent(success: false));
      });
  }


  void loadLocations(int userId) {

    Map<String, LocationModel> locations = {};
    _repository.getLocations()
    .then((value) {
      final decodejson = jsonDecode(value.body);
      for (var key in decodejson) {
        final location = LocationModel(
          id: key['id'],
          name: key['name'],
          floors: key['floors'],
          greenAreas: key['green_zones'],
          restaurants: key['restaurants'],
          obstructions: key['obstructions'],
          latitude: key['latitude'],
          longitude: key['longitude']
          );
        locations.putIfAbsent(key['id'].toString(), () => location);
      };
      return _repository.getRecommendedLocationsNet(userId);
      
    // ignore: invalid_return_type_for_catch_error
    }).then((value) {
      final decodejson = jsonDecode(value.body);
      if (decodejson.length > 0) {  
        for (var key in decodejson) {
          final location = locations[key['id'].toString()];
          if (location != null){
            location.recommended = true;
            locations.update(location.id.toString(), (value) => location);
          }
        }
      }
      _repository.replaceJsonFile(locations);
      notify(LocationsLoadedEvent( success: true));
    
    })
    .catchError((error){
      notifyErrorLoadingLocations(error);
    });
  }

  void _loadCacheInfo(){
    _repository.getRecommendedLocationsCache().then((value) {
      print("Cache de recomendaciones cargado");
      recommendedList = value;
    }).catchError((error){
      recommendedList = [];
    });
    _repository.getBestRatedLocationCache().then((value) {
      print("Cache de mejor valorado cargado");
      bestRated = value;
    }).catchError((error){
      bestRated = "";
    });
  }

  void notifyErrorLoadingLocations(error){
    notify(LoadingEvent(isLoading: false));
    notify(LocationsLoadedEvent(success: false));
  }

 



}


class LoadingEvent extends ViewEvent {
  bool isLoading;
  LoadingEvent({required this.isLoading}) : super("LoadingEvent");
}

class LocationsLoadedEvent extends ViewEvent {
  final bool success;
  LocationsLoadedEvent({ required this.success}) : super("LocationsLoadedEvent");
}

class LocationFrequencyUpdateEvent extends ViewEvent {
  bool success;
  LocationFrequencyUpdateEvent({required this.success}):super("LocationFrequencyUpdateEvent");
}

class LocationsUpdateRecommendendEvent extends ViewEvent {
  final List<UserLocationModel> updatedLocations;
  LocationsUpdateRecommendendEvent({required this.updatedLocations}):super("LocationsUpdateRecommendendEvent");
}

class UpdateRecommendedLocationsEvent extends ViewEvent {
  List<String>? recommendedList = [];
  final bool success;

  UpdateRecommendedLocationsEvent({required this.success, this.recommendedList}):super("UpdateRecommendedLocationsEvent");
}

class UpdateBestRatedLocationsEvent extends ViewEvent {
  final bool success;
  UpdateBestRatedLocationsEvent({required this.success}):super("UpdateBestRatedLocationsEvent");
}



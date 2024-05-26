import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ventura_front/services/repositories/gps_repository.dart';
import '../../mvvm_components/viewmodel.dart';
import '../../mvvm_components/observer.dart';

import '../repositories/locations_repository.dart';
import '../models/location_model.dart';


class LocationsViewModel extends EventViewModel {
  
  static final LocationsViewModel _instance = LocationsViewModel._internal();
  List<String> recommendedList = [];
  String bestRated = "";
  late LocationRepository _repository;
  factory LocationsViewModel() => _instance;
  Map<String, LocationModel> locations = {};
  Map<String, LocationModel> locationsBase = {};
  String closerGreenArea = "";
  String closerRestaurant = "";

  int updatings = 0;

  LocationsViewModel._internal(){
    _repository = LocationRepository();
    _loadCacheInfo();
  
  }

  String getSite(String type){
    if (type == "green_areas" && closerGreenArea.isNotEmpty){
      return closerGreenArea;
    }
    else if (type == "restaurants" && closerRestaurant.isNotEmpty){
      return closerRestaurant;
    }

    Map<String, LocationModel> locationsCopy = locationsBase;
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
      print(key);
      LocationModel location = locationsCopy[key]!;
      if (type == "green_areas" && location.greenAreas > 0){
        closerGreenArea = key;
        return key;
      }
      else if (type == "restaurants" && location.restaurants > 0){
        closerRestaurant = key;
        return key;
      }
    }
    
    return distances.entries.first.key;
    
  }

  List<String>  getSortedIndex(Map<String, double> distances){
    List<MapEntry<String, double>> entries = distances.entries.toList();
    entries.sort((a, b) => a.value.compareTo(b.value));
    List<String> sortedIndices = entries.map((entry) => entry.key).toList();
    return sortedIndices;
  }
  
  void printLocations(){
    for (var key in locations.keys) {
      print(locations[key].toString());
    }
  } 

  void restartLocations(){
    locations = {};
  }

  Map<String, LocationModel> getLocationsBase(){
    return locationsBase;
  }

  void getLocationsCache(){
    locations = {};
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
          notify(LocationsUpdateEvent(success: true));
        }
        else {
          notify(LocationsUpdateEvent(success: false));
        }
      }
    // ignore: invalid_return_type_for_catch_error
    ).catchError((error) {
      print(error.toString());
      notify(LocationsUpdateEvent(success: false));
      return null;
    });
  }

  void updateBestRatedLocationCache(){
    if (bestRated.isNotEmpty){
      LocationModel locationBestRated = locations[bestRated]!;
      locationBestRated.bestRated = true;
      locations.update(bestRated, (value) => locationBestRated);
      notify(LocationsUpdateEvent(success: true));
    }
    else {
      _repository.getBestRatedLocationCache()
      .then((value) {
        if (value.isNotEmpty){
          bestRated = value;
          LocationModel locationBestRated = locations[bestRated]!;
          locationBestRated.bestRated = true;
          locations.update(bestRated, (value) => locationBestRated);
        
          notify(LocationsUpdateEvent(success: true));
        }
        else{
          notify(LocationsUpdateEvent(success: false));
        }
      })
      .catchError((error) {
        notify(LocationsUpdateEvent(success: false)); 
      });
    }
  }

  void updateBestRatedLocationNet(){
    _repository.getBestRatedLocationsNet().then((value) {
      final decodejson = jsonDecode(value.body);
      if (decodejson.length > 0) {  
        if (bestRated.isNotEmpty){
          LocationModel locationBestRated = locations[bestRated]!;
          locationBestRated.bestRated = false;
          locations.update(bestRated, (value) => locationBestRated);
        }
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
        
        notify(LocationsUpdateEvent(success: true));
      }
      else{
        notify(LocationsUpdateEvent(success: false));
      }
    }).catchError((error){
      notify(LocationsUpdateEvent( success: false));
    });
  }

  void updateRecommendedLocationsNet(userId) async{
    print("Actualizando recomendados desde internet");
    _repository.getRecommendedLocationsNet(userId).then((value) {
        final decodejson = jsonDecode(value.body);
        locations = locationsBase;
        if (decodejson.length > 0) {  
          for (var locationId in recommendedList) {
            final location = locations[locationId];
            if (location != null){
              location.recommended = false;
              locations.update(location.id.toString(), (value) => location);
            }
          }
          recommendedList = [];
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
        else{
          recommendedList = [];
          locations = locationsBase;
        }
        _repository.saveRecommendedLocationsCache(recommendedList).then((value) {
          if (value ){
            print("Recomendados guardados en cache");
          }
          else{
            print("Error guardando recomendados en cache");
          }
        });   
        notify(LocationsUpdateEvent(success: true));
      }).catchError((error){
        notify(LocationsUpdateEvent(success: false));
      });
  }

  void cleanCache(){
    locations = locationsBase;
    recommendedList = [];
    bestRated = "";
    _repository.cleanCache().then((value) {
      if (value){
        print("Cache limpiado");
      }
      else{
        print("Error limpiando cache");
      }
    });
  }

  void updateRecommendedLocationsCache() async{
    print("Actualizando recomendados desde cache");
    if (recommendedList.isNotEmpty){
      locations = locationsBase;
      for (var locationId in recommendedList) {
        final location = locations[locationId];
        if (location != null){
          location.recommended = true;
          locations.update(location.id.toString(), (value) => location);
        }
      }
      printLocations();
      notify(LocationsUpdateEvent(success: true));
    }
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
      notify(LocationsLoadedEvent( success: true));
    
    // ignore: invalid_return_type_for_catch_error
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

class LocationsUpdateEvent extends ViewEvent {
  bool success;
  LocationsUpdateEvent({required this.success}):super("LocationsUpdateEvent");
}


import 'dart:convert';
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
  int updatings = 0;
  bool firstTime = true;

  LocationsViewModel._internal(){
    _repository = LocationRepository();
    
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
    distances.entries.toList().sort(((a, b) => a.key.compareTo(b.key)));

    for (var key in distances.keys) {
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
  

  void getLocationsInitial(){
    notify(LoadingEvent(isLoading: true));
    if (locations.isEmpty) {
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
        notify(LoadingEvent(isLoading: false));
        notify(LocationsLoadedEvent( success: true));
      }).catchError((error){
        notify(LoadingEvent(isLoading: false));
        notify(LocationsLoadedEvent(success: false));
      });
    }
    else {
      notify(LocationsLoadedEvent(success: true));
      notify(LoadingEvent(isLoading: false));

    }

  }

  void updateLocationFrequency(userId, locationId ) {
    final defaultModel = UserLocationModel(id: -1, collegeLocation: -1, frequency: -1, user: -1 );
    _repository.updateLocationFrequency(userId, locationId).then(
      (value) {
        if (value.statusCode == 200) {
          final decodejson = jsonDecode(value.body);
          notify(LocationFrequencyUpdateEvent(success: true, model: UserLocationModel.fromJson(decodejson)));
        }
        else {
          notify(LocationFrequencyUpdateEvent(success: false, model: defaultModel));
        }
      }
    // ignore: invalid_return_type_for_catch_error
    ).catchError((error) => {
      notify(LocationFrequencyUpdateEvent(success: false, model: defaultModel))
    });
  }

  void updateRecommendedLocations(userId) async{
    List<String> cache = await _repository.getRecommendedLocations();
    recommendedList = cache;
    if (recommendedList.isNotEmpty){
      print("Cache acccedido");
      for (var locationId in recommendedList) {
        final location = locations[locationId];
        if (location != null){
          location.recommended = true;
          locations.update(location.id.toString(), (value) => location);
        }
      }
      notify(UpdateRecommendedLocationsEvent(success: true, recommendedList: recommendedList));
    }
    else{
      _repository.getRecommendedLocationsFrequency(userId).then((value) {
        final decodejson = jsonDecode(value.body);
        print(decodejson);
        if (decodejson.length > 0) {  

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
        _repository.saveRecommendedLocations(recommendedList).then((value) {
          if (value ){
            print("Recomendados guardados en cache");
          }
          else{
            print("Error guardando recomendados en cache");
          }
        });
          
        notify(UpdateRecommendedLocationsEvent(success: true, recommendedList: recommendedList));
      }).catchError((error){
        print("Erroooorrrr: " +  error.toString());
        notify(UpdateRecommendedLocationsEvent(success: false));
      });
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
      return _repository.getRecommendedLocationsFrequency(userId);
      
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
      notify(LocationsLoadedEvent( success: true));
    
    })
    .catchError((error){
      notifyErrorLoadingLocations(error);
    });
  }

  void getRecommendedLocationsCache(){
    _repository.getRecommendedLocations().then((value) {
      print("Cache de recomendaciones cargado");
      recommendedList = value;
    }).catchError((error){
      recommendedList = [];
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
  UserLocationModel model;
  LocationFrequencyUpdateEvent({required this.success, required this.model}):super("LocationFrequencyUpdateEvent");
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
  final bool loading;
  final bool success;
  UpdateBestRatedLocationsEvent({required this.success, required this.loading}):super("UpdateBestRatedLocationsEvent");
}



import 'dart:convert';

import 'package:ventura_front/services/models/user_model.dart';

import '../../mvvm_components/viewmodel.dart';
import '../../mvvm_components/observer.dart';

import '../repositories/locations_repository.dart';
import '../models/location_model.dart';
import 'package:ventura_front/services/repositories/user_repository.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class LocationsViewModel extends EventViewModel {

  List<LocationModel> locations = [];
  

  final LocationRepository _repository;
  LocationsViewModel(this._repository);

  void updateUbicarButtonClicks(LocationModel location) {
    Map<String, dynamic> jsonData = {
      "location": {
        "name": location.name,
        "latitude": location.latitude,
        "longitude": location.longitude
      },
      "clicks": location
    };

    String jsonString = json.encode(jsonData);
    String fileName = "ubicar_clicks.json";

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child(fileName);

    ref.putString(jsonString).then((firebase_storage.TaskSnapshot storageTask) {
      print("Archivo JSON subido exitosamente a Firebase Storage.");
    }).catchError((error) {
      print("Error al subir el archivo JSON a Firebase Storage: $error");
    });
  }

  void loadLocations() {
    notify(LoadingEvent(isLoading: true));
    _repository.getLocations().then((value) {
      notify(LocationsLoadedEvent(locations: value));
      notify(LoadingEvent(isLoading: false));
    });
  }

}

class LoadingEvent extends ViewEvent {
  bool isLoading;
  LoadingEvent({required this.isLoading}) : super("LoadingEvent");
}

class LocationsLoadedEvent extends ViewEvent {
  final List<LocationModel> locations;

  LocationsLoadedEvent({required this.locations}) : super("LocationsLoadedEvent");
}

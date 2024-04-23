import 'dart:convert';

import '../../mvvm_components/viewmodel.dart';
import '../../mvvm_components/observer.dart';

import '../repositories/locations_repository.dart';
import '../models/location_model.dart';
import '../models/user_location_model.dart';


class LocationsViewModel extends EventViewModel {

  List<LocationModel> locations = [];
  

  final LocationRepository _repository;
  LocationsViewModel(this._repository);

  void updateLocationFrequency(userId, locationId ) {
    final defaultModel = UserLocationModel(id: -1, collegeLocation: -1, frequency: -1, user: -1 );
    _repository.updateLocationFrequency(userId, locationId).then(
      (value) => {
        if (value.statusCode == 200) {
          notify(LocationFrequencyUpdateEvent(success: true, model: defaultModel))
        }
        else {
          notify(LocationFrequencyUpdateEvent(success: false, model: defaultModel))
        }
      }
    // ignore: invalid_return_type_for_catch_error
    ).catchError((error) => {
      notify(LocationFrequencyUpdateEvent(success: false, model: defaultModel))
    });
  }

  void loadLocations() {
    List<LocationModel> locations = [];
    notify(LoadingEvent(isLoading: true));
    _repository.getLocations().then((value) {
      print("Backend locations");
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
        locations.add(location);
        print(location);
      }
      notify(LoadingEvent(isLoading: false));
      notify(LocationsLoadedEvent(locations: locations, success: true));
    // ignore: invalid_return_type_for_catch_error
    }).catchError((error) => notifyErrorLoadingLocations(error));

  }

  void notifyErrorLoadingLocations(error){
    print(error);
    notify(LoadingEvent(isLoading: false));
    notify(LocationsLoadedEvent(locations: [], success: false));
  }


}


class LoadingEvent extends ViewEvent {
  bool isLoading;
  LoadingEvent({required this.isLoading}) : super("LoadingEvent");
}

class LocationsLoadedEvent extends ViewEvent {
  final bool success;
  final List<LocationModel> locations;
  LocationsLoadedEvent({required this.locations, required this.success}) : super("LocationsLoadedEvent");
}

class LocationFrequencyUpdateEvent extends ViewEvent {
  bool success;
  UserLocationModel model;
  LocationFrequencyUpdateEvent({required this.success, required this.model}):super("LocationFrequencyUpdateEvent");
}

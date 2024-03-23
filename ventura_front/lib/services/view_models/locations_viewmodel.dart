import '../../mvvm_components/viewmodel.dart';
import '../../mvvm_components/observer.dart';

import '../repositories/locations_repository.dart';
import '../models/location_model.dart';

class LocationsViewModel extends EventViewModel {

  List<LocationModel> locations = [];
  

  final LocationRepository _repository;
  LocationsViewModel(this._repository);

  void registerLocationClick(LocationModel location) {
    // 
    // 
    // 
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

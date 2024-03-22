import '../models/location_model.dart';
import '../singleton_base.dart';

final class LocationRepository extends SingletonBase<List<LocationModel>>{

  //Singleton Pattern
  static  LocationRepository? _instance;
  LocationRepository._internal() {
    List<LocationModel> locationsInitial = [];
    state = locationsInitial;
  }
  static LocationRepository getState() {
    return _instance ??= LocationRepository._internal();
  } 
  //Singleton Pattern

  // Conection with Firebase Storage

  Future<List<LocationModel>> getLocations() async {
      // Crear instancia si no existe
      if (_instance == null) {
        _instance = LocationRepository.getState();
        return _instance!.state;
      }
      // Si la lista de locations esta vacia, consultar a Firebase Storage
      else if(_instance!.state.isEmpty){
        print("Firebase locations");
        //Consultar a Firebase Storage para obtener la lista de locations
        List<LocationModel> locationsInitial = [
          LocationModel(name: "Bloque A", floors: 2, restaurants: 2, greenAreas: 1, latitude: 1.00000, longitude: 1.00000, obstructions: false),
          LocationModel(name: "Bloque A", floors: 2, restaurants: 2, greenAreas: 1, latitude: 1.00000, longitude: 1.00000, obstructions: false),
          LocationModel(name: "Bloque A", floors: 2, restaurants: 2, greenAreas: 1, latitude: 1.00000, longitude: 1.00000, obstructions: false),
          LocationModel(name: "Bloque A", floors: 2, restaurants: 2, greenAreas: 1, latitude: 1.00000, longitude: 1.00000, obstructions: false)
        ];
        _instance!.setState(locationsInitial);
        return locationsInitial;
      }
      else {
        print("Cache locations");
        return _instance!.state;
      }

  } 
}
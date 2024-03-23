import 'dart:convert';

import 'package:http/http.dart' as http;

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

        List<LocationModel> locationsInitial = [];
        final httpPackageUrl = Uri.parse('https://firebasestorage.googleapis.com/v0/b/ventura-bfe66.appspot.com/o/edificios.json?alt=media&token=948a983d-3398-489a-be43-ffe23ec9493c');
        final httpPackageInfo = await http.read(httpPackageUrl);
        final decodeJson = json.decode(httpPackageInfo);
        final Map<String, dynamic> locations = decodeJson["spaces"] as Map<String, dynamic>;

        for (String key in locations.keys){
              locationsInitial.add(
              LocationModel(name: key, 
              floors: locations[key]["cantidad_pisos"], 
              restaurants: locations[key]["cantidad_restaurantes"], 
              greenAreas: locations[key]["cantidad_zonas_verdes"], 
              latitude: locations[key]["coordenadas"][0], 
              longitude: locations[key]["coordenadas"][1], 
              obstructions: locations[key]["obstrucciones"]
              ));
        }
        _instance!.setState(locationsInitial);
        return locationsInitial;
      }
      else {
        print("Cache locations");
        return _instance!.state;
      }

  } 
}

import 'package:http/http.dart' ;
import '../models/location_model.dart';
import '../singleton_base.dart';
import 'package:flutter_config/flutter_config.dart';

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

  
  Future<Response> updateLocationFrequency(userId, locationId) {
    final Map<String, dynamic> queryParameters = {
      "user_id" : userId.toString(),
      "location_id": locationId.toString()
    } ;
    final url = Uri.https(FlutterConfig.get('API_URL'), "/api/user_frequencies/", queryParameters);
    final package = patch(url);
    return package;
  }

  Future<Response> getLocations() async {
    final url = Uri.http(FlutterConfig.get('API_URL'), "/api/college_locations/");
    final httpPackageInfo = get(url);
    return httpPackageInfo;
  } 
}
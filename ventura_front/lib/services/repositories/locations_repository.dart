import 'package:http/http.dart' ;
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

  
  Future<Response> updateLocationFrequency(userId, locationId) {
    final Map<String, dynamic> queryParameters = {
      "user_id" : userId.toString(),
      "location_id": locationId.toString()
    } ;
    final url = Uri.http("10.0.2.2:8000", "/api/user_frequencies/", queryParameters);
    final package = patch(url);
    return package;
  }

  Future<Response> getLocations() async {
    final url = Uri.http("10.0.2.2:8000", "/api/college_locations/");
    final httpPackageInfo = get(url);
    return httpPackageInfo;
        
  } 
}
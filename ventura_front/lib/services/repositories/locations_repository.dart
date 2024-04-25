import 'package:http/http.dart' ;
import '../models/location_model.dart';
import '../singleton_base.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    String? domain = dotenv.env['API_URL'];
    if (domain != null) {
      final url = Uri.https(domain, "/api/user_frequencies/", queryParameters);
      final package = patch(url);
      return package;
    }
    else{
      return Future.error("Error en la conexión");
    }
  }

  Future<Response> getLocations() async {

    String? domain = dotenv.env['API_URL'];
    if (domain != null) {
      final url = Uri.https(domain, "/api/college_locations/");
      final httpPackageInfo = get(url);
      return httpPackageInfo;
    }
    else{
      return Future.error("Error en la conexión");
    }
  } 
}
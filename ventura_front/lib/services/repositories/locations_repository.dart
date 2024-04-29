import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' ;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class LocationRepository {

  
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
      return patch(url);
    }
    else{
      return Future.error("Error en la conexión");
    }
  }

  Future<Response> getLocations()  {

    String? domain = dotenv.env['API_URL'];
    if (domain != null) {
      final url = Uri.https(domain, "/api/college_locations/");
      return get(url);
    }
    else{
      return Future.error("Error en la conexión");
    }
  }

  Future<Response> getRecommendedLocationsNet(userId) {
    final Map<String, dynamic> queryParameters = {
      "user_id" : userId.toString(),
      "method": "recommended_most_visited"
    } ;
    String? domain = dotenv.env['API_URL'];
    if (domain != null) {
      final url = Uri.https(domain, "/api/user_frequencies/analysis/", queryParameters);
      return get(url);
    }
    else{
      return Future.error("Error en la conexión");
    }
  }

  Future<Response> getBestRatedLocationsNet() {
    final Map<String, dynamic> queryParameters = {
      "method": "best_rated"
    } ;
    String? domain = dotenv.env['API_URL'];
    if (domain != null) {
      final url = Uri.https(domain, "/api/user_frequencies/analysis/", queryParameters);
      return get(url);
    }
    else{
      return Future.error("Error en la conexión");
    }
  }

  Future<bool> saveBestRatedLocationCache(bestRated) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("bestRatedLocation", bestRated);
  }

  Future<String> getBestRatedLocationCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("bestRatedLocation") ?? "";
  }

  Future<bool> cleanCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }


  Future<bool> saveRecommendedLocationsCache(recommendedList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList('recommendedList', recommendedList);
  }

  Future<List<String>> getRecommendedLocationsCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('recommendedList') ?? [];
  }

  void replaceJsonFile(Map<String, dynamic> newJsonContent) {
  // Inicia un nuevo isolate para realizar la operación de reemplazo
  Future<void> replaceJsonIsolate() async {
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(_replaceJsonInIsolate, receivePort.sendPort);
    SendPort sendPort = await receivePort.first;

    // Envía el contenido y la ruta del archivo JSON al isolate
    sendPort.send({
      'newJsonContent': newJsonContent,
    });
  }

  replaceJsonIsolate();
}

void _replaceJsonInIsolate(SendPort sendPort) async {
  ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  await for (var message in receivePort) {
    if (message is Map) {
      Map<String, dynamic> newJsonContent = message['newJsonContent'];

      // Obtén el directorio de almacenamiento local
      Directory appDocDir = Directory.current;
      String appDocPath = appDocDir.path;

      // Define la ruta del archivo JSON
      String jsonFilePath = '$appDocPath/lib/data/initial-locations.json';

      try {
        // Lee el archivo JSON existente
        File file = File(jsonFilePath);
        String jsonData = await file.readAsString();
        Map<String, dynamic> existingJsonContent = json.decode(jsonData);

        // Reemplaza el contenido del archivo con el nuevo contenido
        existingJsonContent = newJsonContent;

        // Escribe el contenido actualizado de nuevo en el archivo
        await file.writeAsString(json.encode(existingJsonContent));

        print('Archivo JSON reemplazado exitosamente.');
      } catch (e) {
        print('Error al reemplazar el archivo JSON: $e');
      }
    }
  }
}

}
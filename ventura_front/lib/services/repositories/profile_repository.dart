import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  int pasos = 1000;
  int calorias = 40;
  int pasosHoy = 0;
  int caloriasHoy = 0;

  Future<void> loadPasos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pasos = prefs.getInt('pasos') ?? 0;
    pasosHoy = prefs.getInt('pasosHoy') ?? 0;
  }

  Future<void> setPasos(int n) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pasos = n;
    await prefs.setInt('pasos', pasos);
  }

  Future<void> addPasos(double distance) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int n = distance ~/ 1.3932;
    pasosHoy = (prefs.getInt('pasosHoy') ?? 0) + n;
    await prefs.setInt('pasosHoy', pasosHoy);
  }

  Future<void> loadCalorias() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    calorias = prefs.getInt('calorias') ?? 0;
    caloriasHoy = prefs.getInt('caloriasHoy') ?? 0;
  }

  Future<void> setCalorias(int n) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    calorias = n;
    await prefs.setInt('calorias', calorias);
  }

  Future<void> addCalorias(double distance) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int n = (distance * 0.062).toInt();
    caloriasHoy = (prefs.getInt('caloriasHoy') ?? 0) + n;
    await prefs.setInt('caloriasHoy', caloriasHoy);
  }
}

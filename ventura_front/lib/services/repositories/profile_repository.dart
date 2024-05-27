import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';


class ProfileRepository {
  int pasos = 1000;
  int calorias = 40;
  int pasosHoy = 0;
  int caloriasHoy = 0;
  File? _image;
  File? get image => _image;

  Future<void> loadPasos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedPasos = prefs.getInt('pasos');
    if (savedPasos != null) {
      pasos = savedPasos;
    }
    int? savedPasosHoy = prefs.getInt('pasosHoy');
    if (savedPasosHoy != null) {
      pasosHoy = savedPasosHoy;
    }
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
    int? savedCalorias = prefs.getInt('calorias');
    if (savedCalorias != null) {
      calorias = savedCalorias;
    }
    int? savedCaloriasHoy = prefs.getInt('caloriasHoy');
    if (savedCaloriasHoy != null) {
      caloriasHoy = savedCaloriasHoy;
    }
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

    Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _image = File(pickedImage.path);
      saveImage(File(pickedImage.path));
    }
  }

  Future<void> saveImage(File image) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatar_image_path', image.path);
  }

  Future<void> loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('avatar_image_path');
    if (imagePath != null) {
      _image = File(imagePath);
    }
  }
}

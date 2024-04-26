import 'package:flutter/material.dart';
import 'package:ventura_front/services/repositories/profile_repository.dart';

class ProfileViewModel with ChangeNotifier {
  final ProfileRepository _profileRepository = ProfileRepository();

  int get pasos => _profileRepository.pasos;
  int get calorias => _profileRepository.calorias;
  int get pasosHoy => _profileRepository.pasosHoy;
  int get caloriasHoy => _profileRepository.caloriasHoy;

  Future<void> loadPasos() async {
    await _profileRepository.loadPasos();
    notifyListeners();
  }

  Future<void> setPasos(int n) async {
    await _profileRepository.setPasos(n);
    notifyListeners();
  }

  Future<void> addPasos(double distance) async {
    await _profileRepository.addPasos(distance);
    notifyListeners();
  }

  Future<void> loadCalorias() async {
    await _profileRepository.loadCalorias();
    notifyListeners();
  }

  Future<void> setCalorias(int n) async {
    await _profileRepository.setCalorias(n);
    notifyListeners();
  }

  Future<void> addCalorias(double distance) async {
    await _profileRepository.addCalorias(distance);
    notifyListeners();
  }
}

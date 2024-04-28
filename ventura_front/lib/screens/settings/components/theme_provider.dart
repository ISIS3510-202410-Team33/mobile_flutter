import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = ThemeData.light();

  ThemeData getTheme() => _themeData;

  void setLightTheme() {
    _themeData = ThemeData.light();
    notifyListeners();
  }

  void setDarkTheme() {
    _themeData = ThemeData.dark();
    notifyListeners();
  }

  Future<void> loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeData = isDarkMode ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    isDarkMode = !isDarkMode;
    await prefs.setBool('isDarkMode', isDarkMode);
    loadThemeFromPrefs();
  }

}

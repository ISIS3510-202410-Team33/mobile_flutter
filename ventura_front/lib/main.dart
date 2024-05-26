import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventura_front/firebase_options.dart';
import 'package:ventura_front/screens/loading/view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ventura_front/screens/settings/components/theme_provider.dart';
import 'package:ventura_front/sensors_components/proximity_sensor.dart';
import 'package:provider/provider.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await loadEnv().catchError((e) => print("Error cargando archivo .env: $e"));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MainApp(isDarkMode: isDarkMode),
    ),
  );
  deleteSharedPreferencesEveryMinute();
}



Future<void> loadEnv() async {
  try {
    dotenv.load(fileName: ".env");
    print("Archivo .env cargado correctamente");
  } on IOException catch (e) {
    print("Error cargando archivo .env: $e");
  }
}  

class MainApp extends StatelessWidget {
  final bool isDarkMode;
  const MainApp({Key? key, required this.isDarkMode}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of
    <ThemeProvider>(context);
    return Proximity(child:MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.getTheme(),
      home: const LoadingView(),
    ),);
  }
}

void deleteSharedPreferencesEveryMinute() {
  Timer.periodic(Duration(seconds: 10), (timer) async {
    print("##################");
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('weather');
  });
}

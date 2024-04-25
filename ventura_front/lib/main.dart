import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ventura_front/firebase_options.dart';
import 'package:ventura_front/screens/loading/view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await loadEnv().catchError((e) => print("Error cargando archivo .env: $e"));
  runApp(const MainApp());
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
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) { 
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
    home: LoadingView(),
    );
  }
}

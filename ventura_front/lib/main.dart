import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ventura_front/firebase_options.dart';
import 'package:ventura_front/screens/loading/view.dart';
import 'package:flutter_config/flutter_config.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  try {
    await FlutterConfig.loadEnvVariables();
  } catch (e) {
    print('Error loading environment variables: $e');
  }
  runApp(const MainApp());
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

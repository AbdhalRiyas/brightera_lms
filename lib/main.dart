import 'package:app/app/config/them_constants.dart';
import 'package:app/app/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arzam Physics',
      debugShowCheckedModeBanner: false,
      theme: ThemConstants.lightTheme,
      home: const HomeScreen(title: 'Arzam Physics'),
    );
  }
}

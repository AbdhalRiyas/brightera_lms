import 'package:app/app/config/app_contants.dart';
import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.openBox(
      AppContants.appStateBox); // this will hold app initial states

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    final box = Hive.box(AppContants.appStateBox);
    box.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brightera',
      debugShowCheckedModeBanner: false,
      theme: ThemeConstants.lightTheme,
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}

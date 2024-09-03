import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/routes.dart';
import 'package:app/app/services/auth_manager.dart';
import 'package:app/app/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            AuthManager().getUserDetails();
          } else {
            AuthManager().setUserDetails(null);
          }
          return MaterialApp(
            title: 'EdPi',
            debugShowCheckedModeBanner: false,
            theme: ThemeConstants.lightTheme,
            onGenerateRoute: routes,
          );
        });
  }
}

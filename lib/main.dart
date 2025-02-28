import 'package:app/src/config/app_contants.dart';
import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/route/routes.dart';
import 'package:app/src/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase only once
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox(AppContants.appStateBox);

  // Initialize Notification Service
  await NotificationService.instance.initialize();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

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
    Hive.box(AppContants.appStateBox).close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brightera',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeConstants.lightTheme,
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}

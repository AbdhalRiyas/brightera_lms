import 'package:app/app/screens/account_screen.dart';
import 'package:app/app/screens/course_screen/course_screen.dart';
import 'package:app/app/screens/home_screen.dart';
import 'package:app/app/screens/lectures_screen/lectures_screen.dart';
import 'package:app/app/screens/login_screen.dart';
import 'package:app/app/services/user_manager.dart';
import 'package:flutter/material.dart';

Route<dynamic>? routes(RouteSettings settings) {
  // A helper function to navigate to the LoginScreen if the user is not authenticated
  Widget getLoginPageIfNeeded() {
    if (UserManager().userDetails == null) {
      return const LoginScreen();
    }
    return const HomeScreen(title: 'EdPi');
  }

  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(title: 'EdPi'),
      );

    case '/login':
      return MaterialPageRoute(
        builder: (context) => getLoginPageIfNeeded(),
      );

    case '/account':
      return MaterialPageRoute(
        builder: (context) => UserManager().userDetails != null
            ? const AccountScreen()
            : const LoginScreen(),
      );

    case '/course':
      final args = settings.arguments as CourseScreenArguments?;
      return MaterialPageRoute(
        builder: (context) => CourseScreen(course: args?.course),
      );

    case '/lectures':
      return MaterialPageRoute(
        builder: (context) => const LecturesScreen(),
      );

    default:
      // Return a fallback route or error page if no matching route is found
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(title: 'EdPi'),
      );
  }
}

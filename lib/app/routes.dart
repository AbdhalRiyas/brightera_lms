import 'package:app/app/screens/course_screen/course_screen.dart';
import 'package:app/app/screens/home_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic>? routes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(
          title: 'EdPi',
        ),
      );
    case '/course':
      final args = settings.arguments as CourseScreenArguments?;
      return MaterialPageRoute(
        builder: (context) => CourseScreen(
          course: args?.course,
        ),
      );
    default:
      // Return null or a fallback route if no matching route is found
      return null;
  }
}

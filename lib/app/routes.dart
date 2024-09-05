import 'package:app/app/screens/account_screen.dart';
import 'package:app/app/screens/courses/course_screen.dart';
import 'package:app/app/screens/home_screen.dart';
import 'package:app/app/screens/lectures_screen/lectures_screen.dart';
import 'package:app/app/screens/list_of_courses_screen/list_of_courses_screen.dart';
import 'package:app/app/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic>? routes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(title: 'EdPi'),
      );

    case '/login':
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );

    case '/account':
      return MaterialPageRoute(
        builder: (context) => const AccountScreen(),
      );

    case '/all-courses':
      final args = settings.arguments as ListOfCoursesScreenArguments?;
      return MaterialPageRoute(
        builder: (context) => ListOfCoursesScreen(
          subject: args?.subject,
        ),
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

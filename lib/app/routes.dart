import 'package:flutter/material.dart';
import 'package:app/app/screens/home_screen.dart';
import 'package:app/app/screens/login_screen/login_screen.dart';
import 'package:app/app/admin/screens/dashboard_screen.dart';
import 'package:app/app/screens/account_screen.dart';
import 'package:app/app/screens/courses/course_screen.dart';
import 'package:app/app/screens/lectures_screen/lectures_screen.dart';
import 'package:app/app/screens/list_of_courses_screen.dart';
import 'package:app/app/services/auth_manager.dart';
import 'package:app/app/models/user.dart';
import 'package:app/app/utils/is_user_authenticated.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:app/app/config/app_contants.dart';

class RouteManager {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final bool isLoggedIn = isUserAuthenticated();

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(title: 'Brightera'),
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
        return _allCoursesRoute(settings);

      case '/course':
        return _courseRoute(settings);

      case '/lectures':
        return _lecturesRoute(isLoggedIn, settings);

      case '/dashboard':
        return _dashboardRoute(isLoggedIn);

      default:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(title: 'Brightera'),
        );
    }
  }

  static Route<dynamic>? _allCoursesRoute(RouteSettings settings) {
    final args = settings.arguments as ListOfCoursesScreenArguments?;
    return MaterialPageRoute(
      builder: (context) => ListOfCoursesScreen(subject: args?.subject),
    );
  }

  static Route<dynamic>? _courseRoute(RouteSettings settings) {
    final args = settings.arguments as CourseScreenArguments?;
    return MaterialPageRoute(
      builder: (context) => CourseScreen(course: args!.course),
    );
  }

  static Route<dynamic>? _lecturesRoute(
      bool isLoggedIn, RouteSettings settings) {
    if (isLoggedIn) {
      final args = settings.arguments as LecturesArguments;
      return MaterialPageRoute(
        builder: (context) => LecturesScreen(course: args.course),
      );
    } else {
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    }
  }

  static Route<dynamic>? _dashboardRoute(bool isLoggedIn) {
    if (isLoggedIn) {
      final userDetails = AuthManager().userDetails;
      if (userDetails?['userRole'] != UserRole.student) {
        final box = Hive.box(AppContants.appStateBox);
        box.put('userRole', userDetails?['userRole']);
        return MaterialPageRoute(
          builder: (context) =>
              const DashboardScreen(title: "Brightera Dashboard"),
        );
      } else {
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(title: 'Brightera'),
        );
      }
    } else {
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    }
  }
}

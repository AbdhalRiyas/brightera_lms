import 'package:app/app/admin/screens/lms/lms_screen.dart';
import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/user.dart';
import 'package:app/app/screens/account_screen.dart';
import 'package:app/app/services/auth_manager.dart';
import 'package:app/app/widgets/bottom_navigation_icon.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.title});

  final String title;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);
  final PageController _pageController = PageController();
  final List<Widget> _tabs = const [
    LmsScreen(),
    Text('Students'),
    AccountScreen(isInstructorView: true),
  ];

  UserRole _userRole = UserRole.instructor;

  @override
  void initState() {
    if (AuthManager().userDetails?['userRole'] == "admin") {
      _userRole = UserRole.admin;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _selectedIndex,
        builder: (context, selectedIndex, child) => Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                useLegacyColorScheme: false,
                selectedLabelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
                backgroundColor: ThemeConstants.backgroundColor,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                      icon: BottomNavigationIcon(
                        path: 'assets/icons/favourite.svg',
                        isActive: selectedIndex == 0,
                      ),
                      label: 'LMS'),
                  BottomNavigationBarItem(
                      icon: BottomNavigationIcon(
                        path: 'assets/icons/play.svg',
                        isActive: selectedIndex == 1,
                      ),
                      label: 'Students'),
                  BottomNavigationBarItem(
                      icon: BottomNavigationIcon(
                        path: 'assets/icons/user.svg',
                        isActive: selectedIndex == 2,
                      ),
                      label: 'Account'),
                ],
                onTap: _onTappedBar,
                currentIndex: selectedIndex,
              ),
              backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
              body: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: _tabs,
                onPageChanged: (page) {
                  _selectedIndex.value = page;
                },
              ),
            ));
  }

  void _onTappedBar(int value) {
    _selectedIndex.value = value;
    _pageController.jumpToPage(value);
  }
}

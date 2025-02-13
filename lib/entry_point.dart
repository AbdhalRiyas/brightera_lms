import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/screens/account/account_screen.dart';
import 'package:app/src/screens/home/home_screen.dart';
import 'package:app/src/screens/my_learning/my_learning_screen.dart';
import 'package:app/src/widgets/bottom_navigation_icon.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key, required this.title});

  final String title;

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  void setupPutNotification() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();

    fcm.subscribeToTopic('notification');
  }

  @override
  void initState() {
    super.initState();
    setupPutNotification();
  }

  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);
  final PageController _pageController = PageController();
  final List<Widget> _tabs = const [
    HomeScreen(),
    // SearchScreen(),
    MyLearningScreen(),
    // FeaturedScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _selectedIndex,
        builder: (context, selectedIndex, child) => Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                useLegacyColorScheme: false,
                selectedLabelStyle: const TextStyle(
                  color: ThemeConstants.primaryColor,
                  fontSize: 12,
                ),
                unselectedLabelStyle: TextStyle(
                  color: ThemeConstants.primaryColor.withAlpha(100),
                  fontSize: 12,
                ),
                // selectedIconTheme: const IconThemeData(
                //   color: ThemeConstants.primaryColor,
                //   size: 2,
                // ),
                // selectedItemColor: ThemeConstants.primaryColor,
                backgroundColor: Colors.white,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: BottomNavigationIcon(
                      path: 'assets/icons/home.svg',
                      isActive: selectedIndex == 0,
                    ),
                    label: 'Home',
                  ),
                  // BottomNavigationBarItem(
                  //   icon: BottomNavigationIcon(
                  //     path: 'assets/icons/favourite.svg',
                  //     isActive: selectedIndex == 1,
                  //   ),
                  //   label: 'Featured',
                  // ),
                  // BottomNavigationBarItem(
                  //   icon: BottomNavigationIcon(
                  //     path: 'assets/icons/search.svg',
                  //     isActive: selectedIndex == 1,
                  //   ),
                  //   label: 'Search',
                  // ),
                  BottomNavigationBarItem(
                      icon: BottomNavigationIcon(
                        path: 'assets/icons/my-learning.svg',
                        isActive: selectedIndex == 1,
                      ),
                      label: 'My Learning'),
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
    _pageController.animateToPage(
      value,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

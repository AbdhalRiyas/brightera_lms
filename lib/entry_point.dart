import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/screens/account_screen.dart';
import 'package:app/src/screens/featured_screen/featured_screen.dart';
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

    final token = await fcm.getToken();
    print('Token: $token');

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
    FeaturedScreen(),
    // Text('My Learning'),
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
                    label: 'Featured',
                  ),
                  BottomNavigationBarItem(
                    icon: BottomNavigationIcon(
                      path: 'assets/icons/search.svg',
                      isActive: selectedIndex == 0,
                    ),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: BottomNavigationIcon(
                      path: 'assets/icons/search.svg',
                      isActive: selectedIndex == 0,
                    ),
                    label: 'My Learning',
                  ),
                  BottomNavigationBarItem(
                    icon: BottomNavigationIcon(
                      path: 'assets/icons/search.svg',
                      isActive: selectedIndex == 0,
                    ),
                    label: 'Wishlist',
                  ),
                  // BottomNavigationBarItem(
                  //     icon: BottomNavigationIcon(
                  //       path: 'assets/icons/play.svg',
                  //       isActive: selectedIndex == 1,
                  //     ),
                  //     label: 'My Learning'),
                  BottomNavigationBarItem(
                      icon: BottomNavigationIcon(
                        path: 'assets/icons/user.svg',
                        isActive: selectedIndex == 1,
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

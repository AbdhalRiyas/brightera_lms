import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/screens/account_screen.dart';
import 'package:app/app/screens/featured_screen/featured_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);
  final PageController _pageController = PageController();
  final List<Widget> _tabs = const [
    FeaturedScreen(),
    Text('My Learning'),
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
                      label: 'Featured'),
                  BottomNavigationBarItem(
                      icon: BottomNavigationIcon(
                        path: 'assets/icons/play.svg',
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
    _pageController.jumpToPage(value);
  }
}

class BottomNavigationIcon extends StatelessWidget {
  final String path;
  final bool isActive;

  const BottomNavigationIcon({
    super.key,
    required this.path,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      colorFilter: ColorFilter.mode(
          isActive ? Colors.black : Colors.black54, BlendMode.srcIn),
    );
  }
}

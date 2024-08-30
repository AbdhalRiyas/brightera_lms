import 'package:app/app/config/theme_constants.dart';
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
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final List<Widget> _tabs = const [
    FeaturedScreen(),
    Text('My Learning'),
    Text('Wishlist'),
    Text('Account'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                isActive: _selectedIndex == 0,
              ),
              label: 'Featured'),
          BottomNavigationBarItem(
              icon: BottomNavigationIcon(
                path: 'assets/icons/play.svg',
                isActive: _selectedIndex == 1,
              ),
              label: 'My Learning'),
          BottomNavigationBarItem(
              icon: BottomNavigationIcon(
                path: 'assets/icons/favourite.svg',
                isActive: _selectedIndex == 2,
              ),
              label: 'Wishlist'),
          BottomNavigationBarItem(
              icon: BottomNavigationIcon(
                path: 'assets/icons/user.svg',
                isActive: _selectedIndex == 3,
              ),
              label: 'Account'),
        ],
        onTap: _onTappedBar,
        currentIndex: _selectedIndex,
      ),
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _tabs,
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
      ),
    );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
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

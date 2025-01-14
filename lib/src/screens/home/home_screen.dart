// home_screen.dart
import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/screens/featured_screen/widgets/carousel.dart';
import 'package:app/src/screens/featured_screen/widgets/courses/courses.dart';
import 'package:app/src/screens/home/popular_course_card.dart';
import 'package:app/src/services/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const WelcomeHeader(),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Carousel(),
                SizedBox(height: ThemeConstants.paddingSmall),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Featured Courses",
                      style: ThemeConstants.headingStyle,
                    ),
                    SizedBox(height: ThemeConstants.paddingSmall),
                    LanguageFilter(),
                    SizedBox(height: ThemeConstants.paddingSmall),
                    FeaturedCourses(),
                  ],
                ),
                SizedBox(height: ThemeConstants.paddingSmall),
                PopularCourses(),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

// welcome_header.dart
class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthManager().getUserDetails(),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Hey, ${AuthManager().userDetails!['name']} 👋 ",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          width: 36,
                          height: 36,
                          decoration: const ShapeDecoration(
                            color: Colors.white,
                            shape: OvalBorder(),
                            shadows: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/bell.svg',
                            // color: ThemeConstants.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const CircleAvatar(
                          radius: 25,

                          // backgroundImage: NetworkImage(
                          //   AuthManager().userDetails!['profilePic'],
                          // ),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}

// language_filter.dart
class LanguageFilter extends StatelessWidget {
  const LanguageFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final languages = ['All', 'English', 'Tamil', 'Sinhala'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 10),
            child: FilterChip(
              showCheckmark: false,
              label: Text(
                languages[index],
                style: TextStyle(
                  color: index == 0 ? Colors.white : Colors.black,
                ),
              ),
              selected: index == 0,
              onSelected: (bool selected) {
                // Implement filter logic here
              },
              selectedColor: ThemeConstants.primaryColor,
            ),
          );
        },
      ),
    );
  }
}

// popular_courses.dart
class PopularCourses extends StatelessWidget {
  const PopularCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Courses',
          style: ThemeConstants.headingStyle,
        ),
        SizedBox(height: 10),
        PopularCourseCard(
          title: 'Figma Course',
          duration: 10,
          price: 2499.0,
          originalPrice: 5499.0,
          image: 'assets/images/books.png',
        ),
        SizedBox(height: 16),
        PopularCourseCard(
          title: 'Science Course',
          duration: 2,
          price: 1999.0,
          originalPrice: 3999.0,
          image: 'assets/images/books.png',
        ),
        SizedBox(height: 16),
        PopularCourseCard(
          title: 'Science Course',
          duration: 2,
          price: 1999.0,
          originalPrice: 3999.0,
          image: 'assets/images/books.png',
        ),
      ],
    );
  }
}

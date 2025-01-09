// home_screen.dart
import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/screens/featured_screen/widgets/carousel.dart';
import 'package:flutter/material.dart';

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
                SizedBox(height: 20),
                LanguageFilter(),
                SizedBox(height: 20),
                FeaturedCourses(),
                SizedBox(height: 30),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back!',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            Text(
              'Hey, Mohamed 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          width: 36,
          height: 36,
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: OvalBorder(),
          ),
          child: const Icon(
            Icons.notifications_none,
          ),
        )
      ],
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

// featured_courses.dart
class FeaturedCourses extends StatelessWidget {
  const FeaturedCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Featured Courses',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              CourseCard(
                title: 'Introduction to Artificial Intelligence (AI)',
                duration: '1h 30m',
                price: 'LKR 1000.00',
                originalPrice: 'LKR 50.00',
                image: 'assets/ai_course.png',
              ),
              CourseCard(
                title: 'Science - Beginning with Physics!',
                duration: '45m',
                price: 'LKR 1899.00',
                originalPrice: 'LKR 3500.00',
                image: 'assets/physics_course.png',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// course_card.dart
class CourseCard extends StatelessWidget {
  final String title;
  final String duration;
  final String price;
  final String originalPrice;
  final String image;

  const CourseCard({
    super.key,
    required this.title,
    required this.duration,
    required this.price,
    required this.originalPrice,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            // child: Image.asset(
            //   image,
            //   height: 100,
            //   width: double.infinity,
            //   fit: BoxFit.cover,
            // ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      originalPrice,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        PopularCourseCard(
          title: 'Figma Course',
          duration: '2h 18m',
          price: 'LKR 2499.00',
          originalPrice: 'LKR 5499.00',
          image: 'assets/figma_course.png',
        ),
        SizedBox(height: 16),
        PopularCourseCard(
          title: 'Science Course',
          duration: '1h 30m',
          price: 'LKR 1999.00',
          originalPrice: 'LKR 3999.00',
          image: 'assets/science_course.png',
        ),
      ],
    );
  }
}

// popular_course_card.dart
class PopularCourseCard extends StatelessWidget {
  final String title;
  final String duration;
  final String price;
  final String originalPrice;
  final String image;

  const PopularCourseCard({
    super.key,
    required this.title,
    required this.duration,
    required this.price,
    required this.originalPrice,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(12)),
            // child: Image.asset(
            //   image,
            //   width: 100,
            //   height: 100,
            //   fit: BoxFit.cover,
            // ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        duration,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        originalPrice,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// custom_bottom_nav_bar.dart
// class CustomBottomNavBar extends StatelessWidget {
//   const CustomBottomNavBar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: 0,
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.search),
//           label: 'Search',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.play_circle_outline),
//           label: 'My Learning',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person_outline),
//           label: 'Account',
//         ),
//       ],
//       selectedItemColor: Colors.blue,
//       unselectedItemColor: Colors.grey,
//       showUnselectedLabels: true,
//     );
//   }
// }

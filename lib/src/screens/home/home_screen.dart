// home_screen.dart
import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/screens/featured_screen/widgets/carousel.dart';
import 'package:app/src/screens/featured_screen/widgets/courses/courses.dart';
import 'package:app/src/services/auth_manager.dart';
import 'package:app/src/widgets/course_card/course_card.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Carousel(),
                const SizedBox(height: ThemeConstants.paddingSmall),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Featured Courses",
                      style: ThemeConstants.headingStyle,
                    ),
                    SizedBox(height: ThemeConstants.paddingSmall),
                    // LanguageFilter(),
                    SizedBox(height: ThemeConstants.paddingSmall),
                    FeaturedCourses(),
                  ],
                ),
                const SizedBox(height: ThemeConstants.paddingSmall),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Categories",
                      style: ThemeConstants.headingStyle,
                    ),
                    TextButton(
                      onPressed: () {
                        // Implement view all categories logic here
                      },
                      child: const Text(
                        "View All",
                        style: TextStyle(
                          color: ThemeConstants.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const Categories(),
                const SizedBox(height: ThemeConstants.paddingSmall),
                const PopularCourses(),
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

// categories.dart
class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> _categories = [
      "Maths",
      "Science",
      "English",
      "History",
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 10),
            child: Chip(
              label: Text(_categories[index]),
            ),
          );
        },
      ),
    );
  }
}

// class CategoryAvatar extends StatelessWidget {
//   const CategoryAvatar({
//     super.key,
//     required this.svgIconPath,
//     required this.categoryTitle,
//   });

//   final String svgIconPath;
//   final String categoryTitle;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(top: 10),
//       margin: const EdgeInsets.only(right: 10),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             width: 60,
//             height: 60,
//             decoration: const ShapeDecoration(
//               color: Colors.white,
//               shape: CircleBorder(),
//               shadows: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 10,
//                 ),
//               ],
//             ),
//             child: SvgPicture.network(
//               svgIconPath,
//               colorFilter: const ColorFilter.mode(
//                 ThemeConstants.primaryColor,
//                 BlendMode.srcIn,
//               ),
//             ),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             categoryTitle,
//             style: const TextStyle(
//               color: Colors.grey,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// popular_courses.dart
class PopularCourses extends StatelessWidget {
  const PopularCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Courses',
          style: ThemeConstants.headingStyle,
        ),
        CourseCard(
          course: Course(
            id: '1',
            title: 'Maths',
            language: 'English',
            image:
                'https://firebasestorage.googleapis.com/v0/b/arzam-physics-app.appspot.com/o/images%2F1726386727792_469221.jpeg?alt=media&token=0dbbe78f-dab9-4c49-a978-161ef47d6785',
            description: 'Learn Maths from the basics to advanced level',
            subject: null,
            salePrice: 0,
            regularPrice: 0,
            durationInHours: 0,
            previewVideo: '',
            instructor: null,
            isFeatured: true,
            isPublished: true,
          ),
          listMode: true,
        ),
      ],
    );
  }
}

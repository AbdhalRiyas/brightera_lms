import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/user.dart';
import 'package:app/app/repositories/user_repository.dart';
import 'package:app/app/screens/featured_screen/widgets/carousel.dart';
import 'package:app/app/screens/featured_screen/widgets/custom_app_bar.dart';
import 'package:app/app/screens/featured_screen/widgets/courses/courses.dart';
import 'package:flutter/material.dart';

class FeaturedScreen extends StatefulWidget {
  const FeaturedScreen({super.key});

  @override
  State<FeaturedScreen> createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: ThemeConstants.backgroundColor,
        body: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              Image.asset(
                "assets/images/hero.webp",
                fit: BoxFit.fill,
                height: constraints.maxHeight * 0.50,
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: constraints.maxHeight * 0.50 - 50,
                        child: const Column(
                          children: [
                            CustomAppBar(),
                            Carousel(),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.all(ThemeConstants.paddingSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Courses",
                              style: ThemeConstants.headingStyle,
                            ),
                            const Courses(),
                            ElevatedButton(
                                onPressed: () {
                                  final UserRepository _userRepository =
                                      UserRepository();

                                  User newUser = User(
                                      id: '19970822',
                                      name: 'Rikas',
                                      mobileNumber: '+94767675740',
                                      userRole: UserRole.instructor);

                                  _userRepository.createUser(
                                    newUser,
                                    '19970822',
                                  );
                                },
                                child: const Text("Create User")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }));
  }

  @override
  bool get wantKeepAlive => true;
}

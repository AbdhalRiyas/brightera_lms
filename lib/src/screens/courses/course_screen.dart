import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/screens/checkout_screen.dart';
import 'package:app/src/screens/courses/widgets/course_cover.dart';
import 'package:app/src/screens/courses/widgets/course_spec_container.dart';
import 'package:app/src/services/firebase_service.dart';
import 'package:app/src/widgets/app_bar_icon.dart';
import 'package:app/src/widgets/syllabus/syllabus_accordion.dart';
import 'package:app/src/screens/lectures_screen/lectures_screen.dart';
import 'package:app/src/utils/format_price.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key, required this.course});

  final Course course;

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final CourseRepository _repository = CourseRepository();
  final ValueNotifier<bool> _activeSubscription = ValueNotifier(false);

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _checkActiveSubscription();
    super.initState();
  }

  void _checkActiveSubscription() async {
    _activeSubscription.value =
        await _repository.checkActiveEnrollment(widget.course.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: const AppBarIcon(),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<User?>(
            stream: FirebaseService().authStateChanges,
            builder: (context, snapshot) {
              return Column(
                children: [
                  CourseCover(course: widget.course),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          widget.course.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: ThemeConstants.paddingSmall),
                        if (widget.course.instructorInfo != null)
                          Text.rich(
                            TextSpan(
                              text: "Taught by ",
                              children: [
                                TextSpan(
                                  text: widget.course.instructorInfo?.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                const TextSpan(text: " in "),
                                TextSpan(text: widget.course.language),
                              ],
                            ),
                            style: const TextStyle(
                              fontSize: ThemeConstants.fontSizeSmall,
                            ),
                          ),
                        const SizedBox(height: ThemeConstants.paddingLarge),
                        SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: TabBar(
                            controller: _tabController,
                            onTap: (index) {
                              setState(() {
                                _tabController.index = index;
                              });
                            },
                            dividerHeight: 0,
                            labelColor: ThemeConstants.primaryButtonColor,
                            unselectedLabelColor: Colors.grey,
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            indicatorWeight: 1,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: ThemeConstants.primaryButtonColor,
                            tabs: const [
                              Tab(
                                text: 'Overview',
                              ),
                              Tab(
                                text: 'Lectures',
                              ),
                            ],
                          ),
                        ),
                        // IndexedStack based on TabBar index
                        IndexedStack(
                          index: _tabController.index,
                          children: [
                            // Ingredients
                            // if (widget.recipe.ingredientsWithQuantites != null)
                            Column(
                              children: [
                                const SizedBox(
                                  height: ThemeConstants.paddingLarge,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CourseSpecContainer(
                                      color: const Color(0x7FA0D1F9),
                                      title: "Total Duration",
                                      icon: "assets/icons/clock.svg",
                                      value: widget.course.durationInHours
                                          .toString(),
                                    ),
                                    CourseSpecContainer(
                                      color: const Color(0x7FF0C7C3),
                                      title: "Language",
                                      icon: "assets/icons/book.svg",
                                      value: widget.course.language,
                                    ),
                                    const CourseSpecContainer(
                                      color: Color(0x3FFFDD67),
                                      title: "Total Students",
                                      icon: "assets/icons/students.svg",
                                      value: "10",
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: ThemeConstants.paddingLarge,
                                ),
                                const Text(
                                  "About course",
                                  style: ThemeConstants.headingStyle,
                                ),
                                Text(
                                  widget.course.description,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SyllabusAccordion(
                              course: widget.course,
                              scrollPhysics:
                                  const NeverScrollableScrollPhysics(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              );
            }),
      ),
      floatingActionButton: CourseButton(
        activeSubscription: _activeSubscription,
        widget: widget,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class CourseButton extends StatelessWidget {
  const CourseButton({
    super.key,
    required ValueNotifier<bool> activeSubscription,
    required this.widget,
  }) : _activeSubscription = activeSubscription;

  final ValueNotifier<bool> _activeSubscription;
  final CourseScreen widget;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _activeSubscription,
      builder: (context, hasEnrolled, ch) {
        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.paddingMedium,
          ),
          child: ElevatedButton(
            onPressed: () => hasEnrolled
                ? Navigator.pushNamed(context, '/lectures',
                    arguments: LecturesArguments(course: widget.course))
                : Navigator.pushNamed(context, '/checkout',
                    arguments: CheckoutScreenArguments([widget.course])),
            child: hasEnrolled
                ? const Text("Start Learning")
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.,
                        children: [
                          Text(
                            formatPrice(widget.course.salePrice),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.course.regularPrice > 0) ...[
                            const SizedBox(width: 10),
                            Text(
                              formatPrice(widget.course.regularPrice),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ]
                        ],
                      ),
                      Row(
                        children: [
                          const VerticalDivider(
                            color: Colors.white,
                            thickness: 1,
                          ),
                          const Text(
                            "Enroll now",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          SvgPicture.asset(
                            "assets/icons/arrow-forward.svg",
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class CourseScreenArguments {
  final Course course;

  CourseScreenArguments(this.course);
}

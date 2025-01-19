import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/screens/checkout_screen.dart';
import 'package:app/src/screens/courses/widgets/course_cover.dart';
import 'package:app/src/screens/courses/widgets/course_spec_container.dart';
import 'package:app/src/services/firebase_service.dart';
import 'package:app/src/widgets/app_bar_back_button.dart';
import 'package:app/src/widgets/syllabus/syllabus_accordion.dart';
import 'package:app/src/screens/lectures_screen/lectures_screen.dart';
import 'package:app/src/utils/format_price.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

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
        leading: const AppBarBackButton(),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.course.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: ThemeConstants.paddingSmall),
                      if (widget.course.instructorInfo != null)
                        Text(
                          "By - ${widget.course.instructorInfo?.name}",
                          style: TextStyle(
                            fontSize: ThemeConstants.fontSizeSmall,
                            color: Colors.black.withAlpha(120),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      // Text.rich(
                      //   TextSpan(
                      //     text: "Taught by ",
                      //     children: [
                      //       TextSpan(
                      //         text: widget.course.instructorInfo?.name,
                      //         style: const TextStyle(
                      //             fontWeight: FontWeight.w600),
                      //       ),
                      //       const TextSpan(text: " in "),
                      //       TextSpan(text: widget.course.language),
                      //     ],
                      //   ),
                      //   style: const TextStyle(
                      //     fontSize: ThemeConstants.fontSizeSmall,
                      //   ),
                      // ),
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
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          indicator: const UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 1.0,
                              color: ThemeConstants.primaryButtonColor,
                            ),
                            insets: EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                          indicatorWeight: 1,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorAnimation: TabIndicatorAnimation.elastic,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    value:
                                        "${widget.course.durationInHours} hours"
                                            .toString(),
                                  ),
                                  CourseSpecContainer(
                                    color: const Color(0x7FF0C7C3),
                                    title: "Language",
                                    icon: "assets/icons/language.svg",
                                    value: widget.course.language,
                                  ),
                                  const CourseSpecContainer(
                                    color: Color(0x3FFFDD67),
                                    title: "Total Students",
                                    icon: "assets/icons/students.svg",
                                    value: "100",
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: ThemeConstants.paddingLarge,
                              ),
                              const Text(
                                "About course",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: ThemeConstants.paddingSmall,
                              ),
                              // Text(
                              //   widget.course.description,
                              //   style: const TextStyle(
                              //     fontSize: 12,
                              //     fontWeight: FontWeight.w400,
                              //   ),
                              // ),
                              ReadMoreText(
                                widget.course.description,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                trimMode: TrimMode.Line,
                                trimLines: 3,
                                colorClickableText: Colors.pink,
                                trimCollapsedText: 'Show more',
                                trimExpandedText: 'Show less',
                                lessStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeConstants.primaryColor,
                                ),
                                moreStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeConstants.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          SyllabusAccordion(
                            course: widget.course,
                            scrollPhysics: const NeverScrollableScrollPhysics(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
              ],
            );
          },
        ),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formatPrice(widget.course.salePrice),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.course.regularPrice > 0) ...[
                            const SizedBox(width: 10),
                            Text(
                              formatPrice(widget.course.regularPrice),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ]
                        ],
                      ),
                      const Row(
                        children: [
                          VerticalDivider(
                            color: ThemeConstants.backgroundColor,
                            thickness: 1,
                          ),
                          SizedBox(width: ThemeConstants.paddingSmall),
                          Text(
                            "Enroll now",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.chevron_right_outlined,
                            size: 32,
                            color: Colors.white,
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

import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/screens/courses/widgets/show_free_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CourseCover extends StatelessWidget {
  const CourseCover({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
      onTap: course.previewVideo.isEmpty
          ? null
          : () => showFreePreview(context, course.previewVideo),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: course.image,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
            if (course.previewVideo.isNotEmpty)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/play-filled.svg',
                        height: 50,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: ThemeConstants.paddingMedium),
                      Text(
                        "Preview this course",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              BoxShadow(
                                  offset: const Offset(1, 1),
                                  blurRadius: 10,
                                  spreadRadius: 10,
                                  color: Colors.grey.shade500),
                            ]),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

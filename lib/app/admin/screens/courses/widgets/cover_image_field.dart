import 'package:app/app/admin/screens/courses/widgets/build_cover_image.dart';
import 'package:app/app/admin/screens/courses/widgets/pick_course_cover.dart';
import 'package:app/app/config/app_contants.dart';
import 'package:flutter/material.dart';

class CoverImageField extends StatelessWidget {
  const CoverImageField({
    super.key,
    required ValueNotifier<String> coverPicture,
  }) : _coverPicture = coverPicture;

  final ValueNotifier<String> _coverPicture;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _coverPicture,
      builder: (_, value, ch) => Column(
        children: [
          buildCoverImage(context, value),
          TextButton(
            onPressed: () async {
              final coverPic = await pickCourseCover(context);
              _coverPicture.value =
                  coverPic?.files.single.path ?? _coverPicture.value;
            },
            child: Text(_coverPicture.value.isNotEmpty &&
                    _coverPicture.value != AppContants.courseCoverPlaceHolder
                ? "Change Course Cover"
                : "Add a Course Cover"),
          ),
        ],
      ),
    );
  }
}

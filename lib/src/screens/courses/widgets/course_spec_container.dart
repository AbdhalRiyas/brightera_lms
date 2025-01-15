import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CourseSpecContainer extends StatelessWidget {
  const CourseSpecContainer({
    super.key,
    required this.color,
    required this.title,
    required this.icon,
    required this.value,
  });

  final Color color;
  final String title;
  final String icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      height: 95,
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 18,
            child: SvgPicture.asset(
              icon,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

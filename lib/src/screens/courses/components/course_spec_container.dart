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
      width: 100,
      height: 100,
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
              colorFilter: ColorFilter.mode(
                color,
                BlendMode.srcIn,
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(0, 0, 0, 0.5),
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

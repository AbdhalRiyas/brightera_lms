import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/subject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubjectButton extends StatelessWidget {
  final String selectedSubject;
  final Subject subject;
  final VoidCallback? onTap;

  const SubjectButton(
      {super.key,
      required this.selectedSubject,
      required this.subject,
      required this.onTap});

  Color _getPillBorderColor(String id) {
    return id == selectedSubject ? ThemeConstants.primaryColor : Colors.black;
  }

  Color _getPillBackgroundColor(String id) {
    return id == selectedSubject
        ? ThemeConstants.primaryButtonColor
        : Colors.transparent;
  }

  Color _getPillTextColor(String id) {
    return id == selectedSubject
        ? ThemeConstants.primaryButtonTextColor
        : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding:
            const EdgeInsets.symmetric(horizontal: ThemeConstants.paddingLarge),
        decoration: BoxDecoration(
          color: _getPillBackgroundColor(subject.id),
          border:
              Border.all(width: 1 / 2, color: _getPillBorderColor(subject.id)),
          borderRadius:
              BorderRadius.circular(ThemeConstants.borderRadiusLarge * 2),
        ),
        child: Center(
          child: Row(
            children: [
              if (subject.icon.startsWith('https://'))
                Padding(
                  padding:
                      const EdgeInsets.only(right: ThemeConstants.paddingSmall),
                  child: SvgPicture.network(
                    subject.icon,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                        _getPillTextColor(subject.id), BlendMode.srcIn),
                  ),
                ),
              Text(
                subject.name,
                style: TextStyle(
                  color: _getPillTextColor(subject.id),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

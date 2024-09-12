import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}

Future<dynamic> enrollNow(
    BuildContext context, Course course, String? userIndex) {
  String encodedMessage = Uri.encodeComponent(
      "Dear Teacher, I would like to enroll into the course ${course.title} on Brightera. ${userIndex != null ? 'My Index is $userIndex' : ''}");
  return showDialog(
    useSafeArea: true,
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "You can enroll via following methods",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: ThemeConstants.paddingMedium),
          ElevatedButton.icon(
            onPressed: () => _launchUrl(
                "https://api.whatsapp.com/send/?phone=${course.instructorInfo?.mobileNumber}&text=$encodedMessage&type=phone_number&app_absent=0"),
            icon: SvgPicture.asset(
              'assets/icons/whatsapp.svg',
              colorFilter: const ColorFilter.mode(
                  ThemeConstants.primaryButtonTextColor, BlendMode.srcIn),
            ),
            label: const Text("WhatsApp Us"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
              foregroundColor: ThemeConstants.primaryButtonTextColor,
              backgroundColor: const Color(0xFF25D366),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () =>
                _launchUrl('tel:+${course.instructorInfo?.mobileNumber}'),
            icon: SvgPicture.asset(
              'assets/icons/call.svg',
              height: 16,
              colorFilter: const ColorFilter.mode(
                  ThemeConstants.primaryButtonTextColor, BlendMode.srcIn),
            ),
            label: const Text("Call Us"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
              foregroundColor: ThemeConstants.primaryButtonTextColor,
              backgroundColor: ThemeConstants.primaryButtonColor,
            ),
          ),
        ],
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.name,
    this.uId,
    required this.imageSrc,
    this.proLableText = "Pro",
    this.press,
    this.isShowHi = true,
  });

  final String name, imageSrc;
  final String? uId;
  final String proLableText;
  final bool isShowHi;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        radius: 28,
        child: SvgPicture.asset(
          imageSrc,
        ),
      ),
      title: Row(
        children: [
          Text(
            isShowHi ? "Hi, $name" : name,
            style: const TextStyle(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 8),
        ],
      ),
      subtitle: uId != null ? Text(uId!) : null,
    );
  }
}

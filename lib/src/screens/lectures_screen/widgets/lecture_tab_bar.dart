import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/active_lesson.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabBarContainer extends StatelessWidget {
  final ValueNotifier<int> selectedIndex;
  final TabController tabController;
  final Function(int) onTabSelected;
  final ValueListenable<ActiveLesson> activeLesson;

  const TabBarContainer({
    super.key,
    required this.selectedIndex,
    required this.tabController,
    required this.onTabSelected,
    required this.activeLesson,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeConstants.primaryShadowColor,
            blurRadius: 16,
          ),
        ],
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.paddingSmall / 2,
        ),
        child: TabBar(
          labelColor: Colors.black,
          labelPadding: const EdgeInsets.all(0),
          dividerHeight: 0,
          indicatorSize: TabBarIndicatorSize.tab,
          tabAlignment: TabAlignment.fill,
          controller: tabController,
          indicatorWeight: 0,
          indicatorPadding: const EdgeInsets.only(bottom: 5, top: 5),
          indicator: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0x3342A5F5),
            borderRadius: BorderRadius.circular(
              ThemeConstants.borderRadiusMedium,
            ),
          ),
          tabs: [
            const TabBarItem(
              iconPath: "assets/icons/lectures.svg",
              label: 'Lectures',
            ),
            ValueListenableBuilder<ActiveLesson>(
              valueListenable: activeLesson,
              builder: (context, value, child) => TabBarItem(
                iconPath: "assets/icons/notes.svg",
                label: 'Notes',
                hasNotes: value.notes.isNotEmpty,
              ),
            ),
            ValueListenableBuilder<ActiveLesson>(
              valueListenable: activeLesson,
              builder: (context, value, child) => TabBarItem(
                iconPath: "assets/icons/downloads.svg",
                label: 'Downloads',
                hasNotes: value.downloads.isNotEmpty,
              ),
            ),
          ],
          onTap: onTabSelected,
        ),
      ),
    );
  }
}

class TabBarItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool hasNotes;

  const TabBarItem({
    super.key,
    required this.iconPath,
    required this.label,
    this.hasNotes = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                height: 20,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          if (hasNotes)
            Positioned(
              top: 0,
              right: 5,
              child: CircleAvatar(
                maxRadius: 5,
                backgroundColor: ThemeConstants.primaryColor.withAlpha(150),
              ),
            ),
        ],
      ),
    );
  }
}

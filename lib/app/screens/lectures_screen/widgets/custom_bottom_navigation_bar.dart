import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/active_lesson.dart';
import 'package:app/app/widgets/bottom_navigation_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar(
      {super.key,
      required this.selectedIndex,
      required this.switchTab,
      required this.activeLesson});

  final ValueNotifier<int> selectedIndex;
  final Function switchTab;
  final ValueListenable<ActiveLesson> activeLesson;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (context, selectedIndex, child) {
          return BottomNavigationBar(
            useLegacyColorScheme: false,
            selectedLabelStyle: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
            backgroundColor: ThemeConstants.backgroundColor,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            onTap: (value) => switchTab(value),
            items: [
              BottomNavigationBarItem(
                icon: BottomNavigationIcon(
                  path: "assets/icons/play.svg",
                  isActive: selectedIndex == 0,
                ),
                label: 'Lectures',
              ),
              BottomNavigationBarItem(
                  icon: ValueListenableBuilder<ActiveLesson>(
                      valueListenable: activeLesson,
                      builder: (context, value, ch) {
                        return BottomNavigationIcon(
                          hasNotes: value.notes.isNotEmpty,
                          path: "assets/icons/notes.svg",
                          isActive: selectedIndex == 1,
                        );
                      }),
                  label: 'Notes'),
              BottomNavigationBarItem(
                  icon: ValueListenableBuilder<ActiveLesson>(
                      valueListenable: activeLesson,
                      builder: (context, value, ch) {
                        return BottomNavigationIcon(
                          hasNotes: value.downloads.isNotEmpty,
                          path: "assets/icons/downloads.svg",
                          isActive: selectedIndex == 2,
                        );
                      }),
                  label: 'Downloads'),
            ],
          );
        });
  }
}

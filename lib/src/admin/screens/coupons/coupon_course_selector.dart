import 'package:app/src/models/course.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CouponCourseSelector extends StatefulWidget {
  final List<Course> availableCourses;
  final List<String> selectedCourses;
  final Function(List<String>) onSelectionChanged;

  const CouponCourseSelector({
    super.key,
    required this.availableCourses,
    required this.selectedCourses,
    required this.onSelectionChanged,
  });

  @override
  State<CouponCourseSelector> createState() => _CouponCourseSelectorState();
}

class _CouponCourseSelectorState extends State<CouponCourseSelector> {
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>.multiSelection(
      mode: Mode.form,
      items: (filter, loadProps) =>
          widget.availableCourses.map((course) => course.title).toList(),
      selectedItems: widget.selectedCourses.map((id) {
        final course = widget.availableCourses.firstWhere(
          (course) => course.id == id,
        );
        return course.title;
      }).toList(),
      popupProps: const PopupPropsMultiSelection.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Search courses",
          ),
        ),
      ),
      decoratorProps: const DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: "Select Courses",
          hintText: "Search and select courses",
        ),
      ),
      onChanged: (List<String> selectedTitles) {
        // Map selected titles back to their IDs
        final selectedIds = selectedTitles.map((title) {
          final course = widget.availableCourses.firstWhere(
            (course) => course.title == title,
          );
          return course.id;
        }).toList();
        widget.onSelectionChanged(selectedIds);
      },
    );
  }
}

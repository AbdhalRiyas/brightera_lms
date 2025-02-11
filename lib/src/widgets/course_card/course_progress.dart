import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/models/section.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CourseProgress extends StatefulWidget {
  const CourseProgress({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  State<CourseProgress> createState() => _CourseProgressState();
}

class _CourseProgressState extends State<CourseProgress> {
  Future<Box>? _courseProgressBox;
  List<Section> _sections = [];
  final FirebaseService _firebaseService = FirebaseService();
  final CourseRepository _courseRepository = CourseRepository();

  Future<void> _fetchSections() async {
    final sections =
        await _courseRepository.fetchSectionsForCourse(widget.course.id);
    setState(() {
      _sections = sections;
    });
  }

  @override
  void initState() {
    super.initState();
    _courseProgressBox = Hive.openBox(
      "${_firebaseService.currentUser?.uid}_${widget.course.id}",
    );
    _fetchSections();
    _courseProgressBox?.then((box) {
      print('Box length: ${box.length}');
      print(box.name);
      print(box.keys);
      print(_sections.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _courseProgressBox,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        return SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: snapshot.hasData
                    ? (snapshot.data as Box).length / 100
                    : 0.0,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  ThemeConstants.primaryColor,
                ),
                strokeWidth: 4,
              ),
              Center(
                child: Text(
                  '${(snapshot.hasData ? (snapshot.data as Box).length : 0)}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// SizedBox(
//       width: 40,
//       height: 40,
//       child: Stack(
//         fit: StackFit.expand,
//         alignment: Alignment.center,
//         children: [
//           CircularProgressIndicator(
//             value: 0.5,
//             backgroundColor: Colors.grey[200],
//             valueColor: const AlwaysStoppedAnimation<Color>(
//               ThemeConstants.primaryColor,
//             ),
//             strokeWidth: 4,
//           ),
//           Center(
//             child: Text(
//               '${(0.5 * 100).toInt()}%',
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );

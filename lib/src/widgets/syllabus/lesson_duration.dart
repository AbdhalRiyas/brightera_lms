import 'package:app/src/models/lecture.dart';
import 'package:app/src/utils/num_extension.dart';
import 'package:app/src/utils/string_extension.dart';
import 'package:flutter/material.dart';

class LessonDuration extends StatefulWidget {
  const LessonDuration({
    super.key,
    required this.lecture,
  });

  final Lecture lecture;

  @override
  State<LessonDuration> createState() => _LessonDurationState();
}

class _LessonDurationState extends State<LessonDuration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _opacityAnimation =
        Tween<double>(begin: 1.0, end: 0.3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.lecture.isLive
        ? AnimatedBuilder(
            animation: _opacityAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation.value,
                child: const Text(
                  "Live video",
                  style: TextStyle(fontSize: 11, color: Colors.red),
                ),
              );
            },
          )
        : Text(
            "${widget.lecture.type.capitalize()} - ${widget.lecture.durationInSeconds.toMinutes()}",
            style: const TextStyle(fontSize: 11),
          );
  }
}

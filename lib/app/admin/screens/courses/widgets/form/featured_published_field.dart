import 'package:flutter/material.dart';

class FeaturedPublishedField extends StatelessWidget {
  const FeaturedPublishedField({
    super.key,
    required ValueNotifier<bool> isFeatured,
    required ValueNotifier<bool> isPublished,
  })  : _isFeatured = isFeatured,
        _isPublished = isPublished;

  final ValueNotifier<bool> _isFeatured;
  final ValueNotifier<bool> _isPublished;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Featured"),
        Expanded(
          child: ValueListenableBuilder<bool>(
              valueListenable: _isFeatured,
              builder: (context, value, ch) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (bool value) {
                    _isFeatured.value = value;
                  },
                );
              }),
        ),
        const SizedBox(width: 10),
        const Text("Published"),
        Expanded(
          child: ValueListenableBuilder<bool>(
              valueListenable: _isPublished,
              builder: (context, value, ch) {
                return Switch.adaptive(
                  value: value,
                  onChanged: (bool value) {
                    _isPublished.value = value;
                  },
                );
              }),
        ),
      ],
    );
  }
}

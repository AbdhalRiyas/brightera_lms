import 'package:app/app/config/theme_constants.dart';
import 'package:flutter/material.dart';

class IndexField extends StatelessWidget {
  const IndexField({
    super.key,
    required TextEditingController indexController,
  }) : _indexController = indexController;

  final TextEditingController _indexController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: ThemeConstants.paddingMedium,
      ),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(
          ThemeConstants.borderRadiusLarge * 2,
        ),
      ),
      child: TextFormField(
        controller: _indexController,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          hintText: 'Index',
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your index number';
          }
          return null;
        },
      ),
    );
  }
}

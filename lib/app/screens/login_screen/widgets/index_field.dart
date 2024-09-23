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
    return Row(
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.paddingMedium),
          decoration: BoxDecoration(
              color: ThemeConstants.inputFieldFill,
              borderRadius:
                  BorderRadius.circular(ThemeConstants.borderRadiusMedium),
              border: Border.all(
                color: ThemeConstants.inputFieldFill,
                width: ThemeConstants.borderSizeLarge,
              )),
          child: Row(
            children: [
              Image.asset(
                "assets/images/lk.webp",
                height: 24,
              ),
              const SizedBox(width: ThemeConstants.paddingSmall),
              const Text("+94"),
            ],
          ),
        ),
        const SizedBox(width: ThemeConstants.paddingSmall),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: ThemeConstants.inputFieldFill,
              borderRadius:
                  BorderRadius.circular(ThemeConstants.borderRadiusMedium),
            ),
            child: TextFormField(
              controller: _indexController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(ThemeConstants.borderRadiusMedium),
                  borderSide: const BorderSide(
                    color: ThemeConstants
                        .inputFieldFill, // Change this to your preferred color
                    width: ThemeConstants.borderSizeLarge,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    ThemeConstants.borderRadiusMedium,
                  ),
                  borderSide: const BorderSide(
                    color: ThemeConstants.primaryColor,
                  ),
                ),
                hintText: 'Mobile number',
                border: InputBorder.none,
                counterText: '',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your mobile number';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}

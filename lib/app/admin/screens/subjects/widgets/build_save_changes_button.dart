// ignore_for_file: use_build_context_synchronously

import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/subject.dart';
import 'package:app/app/repositories/subject_repository.dart';
import 'package:app/app/utils/result.dart';
import 'package:flutter/material.dart';

ElevatedButton buildSaveChangesButton(
    Subject subject,
    bool isActive,
    bool isHidden,
    String name,
    String iconPath,
    SubjectRepository respository,
    void Function(void Function()) setState,
    BuildContext context) {
  return ElevatedButton(
    onPressed: (subject.isActive == isActive &&
            subject.isHidden == isHidden &&
            name == subject.name &&
            subject.icon == iconPath)
        ? null
        : () async {
            bool canUpdate = true;

            if (iconPath != subject.icon) {
              Result result = await respository.uploadIcon(iconPath);

              if (result.isSuccess) {
                iconPath = result.data;
              } else {
                setState(() => iconPath = subject.icon);
                canUpdate = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result.error ?? ''),
                  ),
                );
              }
            }

            if (canUpdate) {
              Subject newSubject = subject.copyWith(
                name: name,
                icon: iconPath,
                isActive: isActive,
                isHidden: isHidden,
              );
              Result result = await respository.updateSubject(newSubject);

              if (result.isSuccess) {
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result.error!),
                  ),
                );
                Navigator.pop(context);
              }
            }
          },
    style: ElevatedButton.styleFrom(
      foregroundColor: ThemeConstants.primaryButtonTextColor,
      backgroundColor: ThemeConstants.primaryButtonColor,
    ),
    child: const Text("Save Changes"),
  );
}

// ignore_for_file: use_build_context_synchronously

import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/subject.dart';
import 'package:app/src/repositories/subject_repository.dart';
import 'package:app/src/utils/result.dart';
import 'package:flutter/material.dart';

ElevatedButton buildSaveChangesButton(
    Subject? subject,
    bool isActive,
    String name,
    String iconPath,
    SubjectRepository respository,
    void Function(void Function()) setState,
    BuildContext context) {
  return ElevatedButton(
    onPressed: ((subject?.isActive == isActive &&
                name == subject?.name &&
                subject?.icon == iconPath) ||
            (iconPath.isEmpty || name.isEmpty))
        ? null
        : () async {
            bool canUpdate = true;

            if (iconPath != subject?.icon) {
              Result result = await respository.uploadIcon(iconPath);

              if (result.isSuccess) {
                iconPath = result.data;
              } else {
                setState(() => iconPath = iconPath);
                canUpdate = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result.error ?? ''),
                  ),
                );
              }
            }

            if (canUpdate) {
              Subject newSubject = subject == null
                  ? Subject(
                      id: '',
                      name: name,
                      isActive: isActive,
                      icon: iconPath,
                    )
                  : subject.copyWith(
                      name: name,
                      icon: iconPath,
                      isActive: isActive,
                    );

              Result result = subject == null
                  ? await respository.createSubject(newSubject)
                  : await respository.updateSubject(newSubject);

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
    child: Text(subject == null ? "Add Subject" : "Save Changes"),
  );
}

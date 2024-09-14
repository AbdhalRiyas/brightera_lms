// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:app/app/admin/screens/subjects/widgets/build_save_changes_button.dart';
import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/subject.dart';
import 'package:app/app/repositories/subject_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'pick_subject_icon.dart';

void addEditSubject(BuildContext context, SubjectRepository respository,
    [Subject? subject]) {
  final nameController = TextEditingController();
  bool isActive = subject?.isActive ?? false;
  nameController.text = subject?.name ?? '';
  String name = nameController.text;
  String iconPath = subject?.icon ?? '';
  FilePickerResult? svgFile;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AlertDialog(
        content: StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) =>
                  Form(
                      child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Subject",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: ThemeConstants.paddingLarge),
              if (iconPath.isNotEmpty)
                Center(
                  child: iconPath.startsWith('http')
                      ? SvgPicture.network(
                          iconPath,
                          height: 28,
                        )
                      : SvgPicture.file(
                          File(iconPath),
                          height: 28,
                        ),
                ),
              TextButton(
                onPressed: () async {
                  svgFile = await pickSubjectIcon(context);
                  setState(
                      () => iconPath = svgFile?.files.single.path ?? iconPath);
                },
                child: Text(
                  iconPath.isEmpty ? "Add Icon" : "Change Icon",
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
                maxLength: 25,
                onChanged: (value) {
                  setState(() => name = value);
                },
              ),
              ListTile(
                title: const Text("Active"),
                contentPadding: EdgeInsets.zero,
                trailing: Switch.adaptive(
                    value: isActive,
                    onChanged: (value) {
                      setState(
                        () => isActive = !isActive,
                      );
                    }),
              ),
              const SizedBox(height: ThemeConstants.paddingMedium),
              buildSaveChangesButton(subject, isActive, name, iconPath,
                  respository, setState, context),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
            ],
          )),
        ),
      ),
    ),
  );
}

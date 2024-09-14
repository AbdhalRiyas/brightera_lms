import 'dart:io';

import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/subject.dart';
import 'package:app/app/repositories/subject_repository.dart';
import 'package:app/app/widgets/seperator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final SubjectRepository _repository = SubjectRepository();

  Future<List<Subject>> _fetchSubjects() async {
    final subjects = await _repository.getAllSubjects();
    return subjects;
  }

  Future<FilePickerResult?> _pickSvgFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['svg'], // Restrict to SVG files
    );

    if ((result == null || result.files.single.extension != 'svg') && mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No .svg icon selected.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('New icon has been selected.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }

    return result;
  }

  void _editSubject(Subject subject) {
    final nameController = TextEditingController();
    bool isActive = subject.isActive;
    bool isHidden = subject.isHidden;
    nameController.text = subject.name;
    String name = nameController.text;
    String iconPath = subject.icon;
    FilePickerResult? svgFile;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context,
                    void Function(void Function()) setState) =>
                Form(
                    child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Edit Subject",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: ThemeConstants.paddingLarge),
                Center(
                  child: iconPath.startsWith('http')
                      ? SvgPicture.network(
                          iconPath,
                          height: 28,
                        )
                      : SvgPicture.file(
                          File(iconPath),
                          // height: 28,
                        ),
                ),
                TextButton(
                  onPressed: () async {
                    svgFile = await _pickSvgFile();
                    setState(() =>
                        iconPath = svgFile?.files.single.path ?? subject.icon);
                  },
                  child: const Text(
                    "Change Icon",
                    style: TextStyle(fontSize: 10),
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
                ListTile(
                  title: const Text("Hide"),
                  contentPadding: EdgeInsets.zero,
                  trailing: Switch.adaptive(
                      value: isHidden,
                      onChanged: (value) {
                        setState(
                          () => isHidden = !isHidden,
                        );
                      }),
                ),
                const SizedBox(height: ThemeConstants.paddingMedium),
                ElevatedButton(
                  onPressed: (subject.isActive == isActive &&
                          subject.isHidden == isHidden &&
                          name == subject.name &&
                          subject.icon == iconPath)
                      ? null
                      : () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ThemeConstants.primaryButtonTextColor,
                    backgroundColor: ThemeConstants.primaryButtonColor,
                  ),
                  child: const Text("Save Changes"),
                ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subjects")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      body: FutureBuilder(
          future: _fetchSubjects(),
          builder: (context, snapshot) {
            return snapshot.connectionState != ConnectionState.done
                ? const Center(child: CircularProgressIndicator.adaptive())
                : snapshot.hasData
                    ? ListView.separated(
                        itemBuilder: (context, i) => ListTile(
                              leading: SvgPicture.network(
                                snapshot.data![i].icon,
                                height: 18,
                              ),
                              title: Text(snapshot.data![i].name),
                              onTap: () => _editSubject(snapshot.data![i]),
                            ),
                        separatorBuilder: (context, i) => const Seperator(),
                        itemCount: snapshot.data?.length ?? 0)
                    : const Text("No subjects has been added");
          }),
    );
  }
}

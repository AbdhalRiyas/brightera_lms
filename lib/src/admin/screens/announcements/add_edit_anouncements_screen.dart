import 'package:app/src/admin/screens/courses/create_course/widgets/build_cover_image.dart';
import 'package:app/src/admin/screens/courses/create_course/widgets/pick_course_cover.dart';
import 'package:app/src/config/app_contants.dart';
import 'package:app/src/models/announcement.dart';
import 'package:app/src/repositories/announcement_repository.dart';
import 'package:app/src/services/firebase_service.dart';
import 'package:app/src/utils/result.dart';
import 'package:flutter/material.dart';

class AddEditAnouncementsScreen extends StatefulWidget {
  const AddEditAnouncementsScreen({
    super.key,
    this.announcement,
  });

  final Announcement? announcement;

  @override
  State<AddEditAnouncementsScreen> createState() =>
      _AddEditAnouncementsScreenState();
}

class _AddEditAnouncementsScreenState extends State<AddEditAnouncementsScreen> {
  final _formKey = GlobalKey<FormState>();
  final AnnouncementRepository _repository = AnnouncementRepository();
  final FirebaseService _firebaseService = FirebaseService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _shortDescriptionController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ValueNotifier<String?> _imageUrl = ValueNotifier('');

  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _imageUrl.value =
        widget.announcement == null || widget.announcement!.imageUrl!.isEmpty
            ? AppContants.courseCoverPlaceHolder
            : widget.announcement!.imageUrl;
    _titleController.text = widget.announcement?.title ?? '';
    _shortDescriptionController.text =
        widget.announcement?.shortDescription ?? '';
    _descriptionController.text = widget.announcement?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.announcement != null
                ? "Edit Announcement"
                : "Add Announcement",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ValueListenableBuilder<String?>(
                      valueListenable: _imageUrl,
                      builder: (_, value, ch) => Column(
                        children: [
                          buildImage(context, value!),
                          TextButton(
                            onPressed: () async {
                              final coverPic = await pickImage(context);
                              _imageUrl.value = coverPic?.files.single.path ??
                                  _imageUrl.value;
                            },
                            child: Text(
                              _imageUrl.value!.isNotEmpty &&
                                      _imageUrl.value !=
                                          AppContants.courseCoverPlaceHolder
                                  ? "Change Banner"
                                  : "Add Banner",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: "Title"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Title is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _shortDescriptionController,
                      decoration: const InputDecoration(
                        labelText: "Short Description",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Short Description is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Description is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isSending
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isSending = true;
                                });
                                bool canUpdate = true;

                                if (_imageUrl.value !=
                                    widget.announcement?.imageUrl) {
                                  Result result =
                                      await _repository.uploadAnnouncementImage(
                                          _imageUrl.value!);

                                  if (result.isSuccess) {
                                    _imageUrl.value = result.data;
                                  } else {
                                    _imageUrl.value =
                                        widget.announcement?.imageUrl ??
                                            AppContants.courseCoverPlaceHolder;
                                    canUpdate = false;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(result.error ?? ''),
                                      ),
                                    );
                                  }
                                }

                                if (canUpdate) {
                                  Announcement announcement = widget
                                              .announcement ==
                                          null
                                      ? Announcement(
                                          id: '',
                                          title: _titleController.text,
                                          shortDescription:
                                              _shortDescriptionController.text,
                                          description:
                                              _descriptionController.text,
                                          imageUrl: _imageUrl.value,
                                          createdAt: DateTime.now(),
                                        )
                                      : Announcement(
                                          id: widget.announcement!.id,
                                          title: _titleController.text,
                                          shortDescription:
                                              _shortDescriptionController.text,
                                          description:
                                              _descriptionController.text,
                                          imageUrl: _imageUrl.value,
                                          createdAt:
                                              widget.announcement!.createdAt,
                                        );
                                  final Result result =
                                      widget.announcement == null
                                          ? await _repository
                                              .addAnnouncement(announcement)
                                          : await _repository
                                              .updateAnnouncement(announcement);

                                  if (widget.announcement == null) {
                                    await _firebaseService
                                        .sendNotificationToAll(
                                      title: announcement.title,
                                      body: announcement.shortDescription,
                                      type: 'announcement',
                                    );
                                  }

                                  if (result.isSuccess) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          widget.announcement != null
                                              ? "Announcement Updated Successfully"
                                              : "Announcement Created Successfully",
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(result.error ?? ''),
                                      ),
                                    );
                                  }
                                }

                                setState(() {
                                  _isSending = false;
                                });
                              }
                            },
                      child: Text(
                        widget.announcement != null
                            ? "Update Announcement"
                            : "Add Announcement",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:app/src/admin/screens/courses/create_course/widgets/build_cover_image.dart';
import 'package:app/src/admin/screens/courses/create_course/widgets/pick_course_cover.dart';
import 'package:app/src/admin/screens/lms_screen.dart';
import 'package:app/src/config/app_contants.dart';
import 'package:app/src/models/app_banner.dart';
import 'package:app/src/repositories/banner_respository.dart';
import 'package:app/src/utils/result.dart';
import 'package:flutter/material.dart';

class BannerAddEditScreen extends StatefulWidget {
  const BannerAddEditScreen({super.key, this.appbanner});

  final Appbanner? appbanner;

  @override
  State<BannerAddEditScreen> createState() => _BannerAddEditScreenState();
}

class _BannerAddEditScreenState extends State<BannerAddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final BannerRespository _repository = BannerRespository();

  final ValueNotifier<String> _banner = ValueNotifier('');
  final ValueNotifier<bool> _isHidden = ValueNotifier(false);
  final ValueNotifier<int> _order = ValueNotifier(1);
  final ValueNotifier<String> _link = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    _banner.value =
        widget.appbanner == null || widget.appbanner!.imagePath.isEmpty
            ? AppContants.courseCoverPlaceHolder
            : widget.appbanner!.imagePath;
    _isHidden.value = widget.appbanner?.isHidden ?? false;
    _order.value = widget.appbanner?.order ?? 0;
    _link.value = widget.appbanner?.link ?? '';
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
            widget.appbanner != null ? "Edit Banner" : "Create a Banner",
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
                    ValueListenableBuilder<String>(
                      valueListenable: _banner,
                      builder: (_, value, ch) => Column(
                        children: [
                          buildImage(context, value),
                          TextButton(
                            onPressed: () async {
                              final coverPic = await pickImage(context);
                              _banner.value =
                                  coverPic?.files.single.path ?? _banner.value;
                            },
                            child: Text(
                              _banner.value.isNotEmpty &&
                                      _banner.value !=
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
                      initialValue: _link.value,
                      decoration: const InputDecoration(
                        labelText: 'Link',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a link';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _link.value = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: widget.appbanner?.order.toString() ?? '',
                      decoration: const InputDecoration(
                        labelText: 'Order',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an order';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _order.value = int.parse(value);
                      },
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<bool>(
                      valueListenable: _isHidden,
                      builder: (_, value, ch) => SwitchListTile(
                        title: const Text('Hide Banner'),
                        value: value,
                        onChanged: (val) {
                          _isHidden.value = val;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool canUpdate = true;

                          if (_banner.value != widget.appbanner?.imagePath) {
                            Result result = await _repository
                                .uploadBannerImage(_banner.value);

                            if (result.isSuccess) {
                              _banner.value = result.data;
                            } else {
                              _banner.value = widget.appbanner?.imagePath ??
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
                            Appbanner newBanner = widget.appbanner == null
                                ? Appbanner(
                                    id: '',
                                    imagePath: _banner.value,
                                    isHidden: _isHidden.value,
                                    link: _link.value,
                                    order: _order.value,
                                  )
                                : widget.appbanner!.copyWith(
                                    imagePath: _banner.value,
                                    isHidden: _isHidden.value,
                                    link: _link.value,
                                    order: _order.value,
                                  );
                            final Result result = widget.appbanner != null
                                ? await _repository.updateBanner(newBanner)
                                : await _repository.addBanner(newBanner);

                            if (result.isSuccess) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const LmsScreen(),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    widget.appbanner != null
                                        ? "Banner Updated Successfully"
                                        : "Banner Created Successfully",
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
                        }
                      },
                      child: Text(widget.appbanner != null
                          ? "Update Banner"
                          : "Create Banner"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

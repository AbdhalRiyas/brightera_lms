import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/src/models/coupon.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/repositories/coupon_repository.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/utils/result.dart';
import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/admin/screens/coupons/coupon_course_selector.dart';

class CouponAddEditScreen extends StatefulWidget {
  const CouponAddEditScreen({
    super.key,
    required this.repository,
    this.coupon,
  });

  final CouponRepository repository;
  final Coupon? coupon;

  @override
  State<CouponAddEditScreen> createState() => _CouponAddEditScreenState();
}

class _CouponAddEditScreenState extends State<CouponAddEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _studentIdsController = TextEditingController();
  final TextEditingController _couponCodeController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _maxUsageController = TextEditingController();

  final ValueNotifier<DateTime?> _selectedDate = ValueNotifier(null);
  final ValueNotifier<DiscountType?> _couponType = ValueNotifier(null);
  final ValueNotifier<bool> _appliesToAllCourses = ValueNotifier(false);
  final ValueNotifier<bool> _isActive = ValueNotifier(true);
  final ValueNotifier<List<String>> _selectedStudents = ValueNotifier([]);
  final ValueNotifier<List<String>> _selectedCourses = ValueNotifier([]);
  final ValueNotifier<List<Course>> _availableCourses = ValueNotifier([]);

  @override
  void initState() {
    _couponCodeController.text = widget.coupon?.code ?? '';
    _discountController.text = widget.coupon?.discount.toString() ?? '';
    _expiryDateController.text =
        widget.coupon?.expiryDate?.toLocal().toString().split(' ')[0] ?? '';
    _maxUsageController.text = widget.coupon?.maxUsage.toString() ?? '';
    _couponType.value = widget.coupon?.type;
    _selectedDate.value = widget.coupon?.expiryDate;
    _appliesToAllCourses.value =
        widget.coupon?.courseIds?.contains('*') ?? false;
    _selectedCourses.value = widget.coupon?.courseIds ?? [];
    _selectedStudents.value = widget.coupon?.studentIds ?? [];
    _fetchCourses();
    super.initState();
  }

  Future<void> _fetchCourses() async {
    final courses = await CourseRepository().getCourses();
    _availableCourses.value = courses;
  }

  @override
  void dispose() {
    _couponCodeController.dispose();
    _discountController.dispose();
    _expiryDateController.dispose();
    _maxUsageController.dispose();
    _studentIdsController.dispose();
    super.dispose();
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
          title: Text(widget.coupon == null ? 'Create Coupon' : 'Edit Coupon'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.paddingMedium,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Coupon Code Field
                  widget.coupon != null
                      ? Text("Coupon Code: ${widget.coupon!.code}",
                          style: const TextStyle(fontSize: 24))
                      : TextFormField(
                          controller: _couponCodeController,
                          decoration:
                              const InputDecoration(labelText: 'Coupon Code'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Coupon Code is required';
                            }
                            return null;
                          },
                        ),
                  ValueListenableBuilder<DiscountType?>(
                    valueListenable: _couponType,
                    builder: (context, couponType, _) {
                      return DropdownButtonFormField<DiscountType>(
                        value: couponType,
                        items: const [
                          DropdownMenuItem(
                            value: DiscountType.percentage,
                            child: Text('Percentage'),
                          ),
                          DropdownMenuItem(
                            value: DiscountType.fixedAmount,
                            child: Text('Fixed Amount'),
                          ),
                        ],
                        onChanged: (value) {
                          _couponType.value = value;
                          _discountController.clear();
                        },
                        decoration:
                            const InputDecoration(labelText: 'Discount Type'),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a discount type';
                          }
                          return null;
                        },
                      );
                    },
                  ),

                  // Discount Field
                  ValueListenableBuilder<DiscountType?>(
                    valueListenable: _couponType,
                    builder: (context, couponType, _) {
                      return TextFormField(
                        controller: _discountController,
                        decoration: InputDecoration(
                          labelText: couponType == DiscountType.percentage
                              ? 'Discount (%)'
                              : 'Discount (Fixed Amount)',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Discount is required';
                          }
                          final discountValue = double.tryParse(value);
                          if (discountValue == null) {
                            return 'Enter a valid number';
                          }
                          if (couponType == DiscountType.percentage) {
                            if (discountValue <= 0 || discountValue > 100) {
                              return 'Enter a percentage between 1 and 100';
                            }
                          } else if (couponType == DiscountType.fixedAmount) {
                            if (discountValue <= 0) {
                              return 'Enter a positive fixed amount';
                            }
                          }
                          return null;
                        },
                      );
                    },
                  ),

                  // Max Usage Field
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Max Usage'),
                    keyboardType: TextInputType.number,
                    controller: _maxUsageController,
                  ),
                  // Expiry Date Field
                  TextFormField(
                    controller: _expiryDateController,
                    decoration: const InputDecoration(labelText: 'Expiry Date'),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                  ),

                  // Applies To Field
                  ValueListenableBuilder<bool>(
                    valueListenable: _appliesToAllCourses,
                    builder: (context, appliesToAllCourses, _) {
                      return SwitchListTile(
                        title: const Text('Applies to All Courses'),
                        value: appliesToAllCourses,
                        onChanged: (value) {
                          _appliesToAllCourses.value = value;
                          if (value) {
                            _selectedCourses.value = [];
                          } else {
                            _selectedCourses.value =
                                _selectedCourses.value.contains('*')
                                    ? []
                                    : _selectedCourses.value;
                          }
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _appliesToAllCourses,
                    builder: (context, appliesToAllCourses, _) {
                      if (!appliesToAllCourses) {
                        return ValueListenableBuilder<List<Course>>(
                          valueListenable: _availableCourses,
                          builder: (context, availableCourses, _) {
                            return _availableCourses.value.isEmpty
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : CouponCourseSelector(
                                    availableCourses: availableCourses,
                                    selectedCourses: _selectedCourses.value,
                                    onSelectionChanged: (selectedCourses) {
                                      _selectedCourses.value = selectedCourses;
                                    },
                                  );
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),

                  ValueListenableBuilder<bool>(
                    valueListenable: _isActive,
                    builder: (context, isActive, _) {
                      return SwitchListTile(
                        title: const Text('Activate Coupon'),
                        value: isActive,
                        onChanged: (value) {
                          _isActive.value = value;
                        },
                      );
                    },
                  ),

                  // Student IDs Field
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _studentIdsController,
                          decoration: const InputDecoration(
                            labelText: 'Add Student ID',
                            hintText: 'Ex: 94712345678',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                          onFieldSubmitted: (value) {
                            _studentIdsController.clear();
                            if (value.isNotEmpty) {
                              _selectedStudents.value = [
                                ..._selectedStudents.value,
                                value
                              ];
                            }
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_studentIdsController.text.isNotEmpty) {
                            _selectedStudents.value = [
                              ..._selectedStudents.value,
                              _studentIdsController.text
                            ];
                            _studentIdsController.clear();
                          }
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  ValueListenableBuilder<List<String>>(
                    valueListenable: _selectedStudents,
                    builder: (context, selectedStudents, _) {
                      return Wrap(
                        spacing: 8.0,
                        children: selectedStudents.map((studentId) {
                          return Chip(
                            label: Text(studentId),
                            onDeleted: () {
                              _selectedStudents.value =
                                  List.from(selectedStudents)
                                    ..remove(studentId);
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                  // Add Number Button

                  const SizedBox(height: 20),

                  // Create/Update Button
                  ElevatedButton(
                    onPressed: _onSubmit,
                    child: Text(widget.coupon == null ? 'Create' : 'Update'),
                  ),

                  // Cancel Button
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: widget.coupon?.expiryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (newSelectedDate != null) {
      _selectedDate.value = newSelectedDate;
      _expiryDateController.text =
          _selectedDate.value!.toLocal().toString().split(' ')[0];
    }
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final coupon = Coupon(
        code: widget.coupon == null
            ? _couponCodeController.text
            : widget.coupon!.code,
        discount: double.parse(_discountController.text),
        isActive: _isActive.value,
        usageCount: 0,
        type: _couponType.value!,
        createdAt: DateTime.now(),
        expiryDate: _selectedDate.value,
        maxUsage: _maxUsageController.text.isNotEmpty
            ? int.parse(_maxUsageController.text)
            : null,
        courseIds: _appliesToAllCourses.value ? ['*'] : _selectedCourses.value,
        studentIds:
            _selectedStudents.value.isNotEmpty ? _selectedStudents.value : null,
      );

      final Result result = widget.coupon == null
          ? await widget.repository.createCoupon(coupon)
          : await widget.repository.updateCoupon(coupon);

      if (result.isSuccess) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Coupon ${widget.coupon == null ? 'created' : 'updated'} successfully',
            ),
            backgroundColor: result.isSuccess ? Colors.green : Colors.red,
          ),
        );
      } else if (result.isError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

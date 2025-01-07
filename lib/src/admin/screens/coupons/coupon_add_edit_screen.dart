import 'package:app/src/admin/screens/coupons/coupon_course_selector.dart';
import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/coupon.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/repositories/coupon_repository.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CouponAddEditDialog extends StatefulWidget {
  const CouponAddEditDialog({
    super.key,
    required this.repository,
    this.coupon,
  });

  final CouponRepository repository;
  final Coupon? coupon;

  @override
  State<CouponAddEditDialog> createState() => _CouponAddEditDialogState();
}

class _CouponAddEditDialogState extends State<CouponAddEditDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _studentIdsController = TextEditingController();
  final TextEditingController _couponCodeController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _maxUsageController = TextEditingController();
  final ValueNotifier<DateTime?> _selectedDate = ValueNotifier(null);
  final ValueNotifier<DiscountType?> _couponType = ValueNotifier(null);

  late bool _appliesToAllCourses;
  bool isActive = true;
  List<String> _selectedStudents = [];
  List<String> _selectedCourses = [];
  List<Course> _availableCourses = [];

  @override
  void initState() {
    _couponCodeController.text = widget.coupon?.code ?? '';
    _discountController.text = widget.coupon?.discount.toString() ?? '';
    _expiryDateController.text =
        widget.coupon?.expiryDate?.toLocal().toString().split(' ')[0] ?? '';
    _maxUsageController.text = widget.coupon?.maxUsage.toString() ?? '';
    _couponType.value = widget.coupon?.type;
    _selectedDate.value = widget.coupon?.expiryDate;
    _appliesToAllCourses = widget.coupon?.courseIds!.contains('*') ?? false;
    _selectedCourses = widget.coupon?.courseIds ?? [];
    _selectedStudents = widget.coupon?.studentIds ?? [];
    _fetchCourses();
    super.initState();
  }

  Future<void> _fetchCourses() async {
    final courses = await CourseRepository().getCourses(); // Fetch courses
    setState(() {
      _availableCourses = courses;
    });
  }

  @override
  void dispose() {
    _couponCodeController.dispose();
    _discountController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                TextFormField(
                  controller: _couponCodeController,
                  decoration: const InputDecoration(labelText: 'Coupon Code'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Coupon Code is required';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<DiscountType>(
                  value: _couponType.value,
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
                    setState(() {
                      _couponType.value = value;
                      _discountController
                          .clear(); // Clear discount field to avoid confusion
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Discount Type'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a discount type';
                    }
                    return null;
                  },
                ),
                // Discount Field
                TextFormField(
                  controller: _discountController,
                  decoration: InputDecoration(
                    labelText: _couponType.value == DiscountType.percentage
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
                    if (_couponType == DiscountType.percentage) {
                      if (discountValue <= 0 || discountValue > 100) {
                        return 'Enter a percentage between 1 and 100';
                      }
                    } else if (_couponType == DiscountType.fixedAmount) {
                      if (discountValue <= 0) {
                        return 'Enter a positive fixed amount';
                      }
                    }
                    return null;
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
                SwitchListTile(
                  title: const Text('Applies to All Courses'),
                  value: _appliesToAllCourses,
                  onChanged: (value) {
                    setState(() {
                      _appliesToAllCourses = value;
                      if (value) {
                        _selectedCourses.clear();
                      } else {
                        widget.coupon?.courseIds?.clear();
                        _selectedCourses = widget.coupon?.courseIds ?? [];
                      }
                    });
                  },
                ),

                if (!_appliesToAllCourses)
                  CouponCourseSelector(
                    availableCourses: _availableCourses,
                    selectedCourses: _selectedCourses,
                    onSelectionChanged: (selectedCourses) {
                      setState(() {
                        _selectedCourses = selectedCourses;
                      });
                    },
                  ),

                SwitchListTile(
                  title: const Text('Activate Coupon'),
                  value: isActive,
                  onChanged: (value) {
                    setState(() {
                      isActive = value;
                    });
                  },
                ),

                // text field to add multiple student ids and chip view to read and delete
                TextFormField(
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
                      setState(() {
                        _selectedStudents.add(value);
                      });
                    }
                  },
                ),
                Wrap(
                  spacing: 8.0,
                  children: _selectedStudents.map((studentId) {
                    return Chip(
                      label: Text(studentId),
                      onDeleted: () {
                        setState(() {
                          _selectedStudents.remove(studentId);
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),
                // Create Button
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
      setState(() {
        _selectedDate.value = newSelectedDate;
        _expiryDateController.text =
            _selectedDate.value!.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final coupon = Coupon(
        code: _couponCodeController.text.trim(),
        discount: double.parse(_discountController.text),
        isActive: isActive,
        usageCount: 0,
        type: _couponType.value!,
        createdAt: DateTime.now(),
        expiryDate: _selectedDate.value,
        maxUsage: _maxUsageController.text.isNotEmpty
            ? int.parse(_maxUsageController.text)
            : null,
        courseIds: _appliesToAllCourses ? ['*'] : _selectedCourses,
        studentIds: _selectedStudents.isNotEmpty ? _selectedStudents : null,
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

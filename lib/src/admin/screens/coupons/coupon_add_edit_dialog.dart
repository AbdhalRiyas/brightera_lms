import 'package:app/src/models/coupon.dart';
import 'package:app/src/repositories/coupon_repository.dart';
import 'package:app/src/utils/result.dart';
import 'package:flutter/material.dart';

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
  late final TextEditingController _couponCodeController;
  late final TextEditingController _discountController;
  late final TextEditingController _expiryDateController;
  CouponType? _couponType;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _couponCodeController =
        TextEditingController(text: widget.coupon?.code ?? '');
    _discountController =
        TextEditingController(text: widget.coupon?.discount.toString() ?? '');
    _expiryDateController = TextEditingController(
      text: widget.coupon?.expiryDate?.toLocal().toString().split(' ')[0] ?? '',
    );
    _couponType = widget.coupon?.type;
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
    return AlertDialog(
      title: Text(widget.coupon == null ? 'Create Coupon' : 'Edit Coupon'),
      content: Form(
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
              // Coupon Type Dropdown
              DropdownButtonFormField<CouponType>(
                value: _couponType,
                items: const [
                  DropdownMenuItem(
                    value: CouponType.percentage,
                    child: Text('Percentage'),
                  ),
                  DropdownMenuItem(
                    value: CouponType.fixedAmount,
                    child: Text('Fixed Amount'),
                  ),
                ],
                onChanged: (value) => setState(() {
                  _couponType = value;
                }),
                decoration: const InputDecoration(labelText: 'Coupon Type'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a coupon type';
                  }
                  return null;
                },
              ),
              // Discount Field
              TextFormField(
                controller: _discountController,
                decoration: const InputDecoration(labelText: 'Discount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Discount is required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              // Max Usage Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Max Usage'),
                keyboardType: TextInputType.number,
              ),
              // Expiry Date Field
              TextFormField(
                controller: _expiryDateController,
                decoration: const InputDecoration(labelText: 'Expiry Date'),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Expiry date is required';
                  }
                  return null;
                },
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
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate = newSelectedDate;
        _expiryDateController.text =
            _selectedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final coupon = Coupon(
        id: widget.coupon?.id ?? '',
        code: _couponCodeController.text.trim().toUpperCase(),
        discount: double.parse(_discountController.text),
        maxUsage: 0,
        appliesTo: [],
        type: _couponType!,
        expiryDate: _selectedDate,
      );

      final Result result = await widget.repository.createCoupon(coupon);
      if (result.isSuccess) {
        print(
            'Coupon ${widget.coupon == null ? 'created' : 'updated'} successfully');
        Navigator.pop(context);
      } else if (result.isError) {
        print('Error: ${result.error}');
      }
    }
  }
}

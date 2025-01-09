import 'package:app/src/admin/screens/coupons/coupon_add_edit_screen.dart';
import 'package:app/src/models/coupon.dart';
import 'package:app/src/repositories/coupon_repository.dart';
import 'package:app/src/utils/result.dart';
import 'package:flutter/material.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  final CouponRepository _repository = CouponRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coupons'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  CouponAddEditDialog(repository: _repository),
            ),
          );
        },
      ),
      body: StreamBuilder(
        stream: _repository.getCouponsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.hasData) {
            final coupons = snapshot.data!;
            return ListView.builder(
              itemBuilder: (context, i) {
                final coupon = coupons[i];
                return Dismissible(
                  key: Key(coupon.code),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    Result result = await _repository.deleteCoupon(coupon.code);
                    scaffoldMessenger.clearSnackBars();
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text(result.data ?? result.error),
                        backgroundColor:
                            result.isSuccess ? Colors.green : Colors.red,
                      ),
                    );
                    return result.isSuccess;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.only(right: 16),
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(coupon.code),
                    subtitle: coupon.type == DiscountType.percentage
                        ? Text('${coupon.discount}% off')
                        : Text('LKR ${coupon.discount} off'),
                    trailing: Text(
                      'No. of uses: ${coupon.usageCount.toString()}/${coupon.maxUsage}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CouponAddEditDialog(
                            coupon: coupon,
                            repository: _repository,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              itemCount: coupons.length,
            );
          } else {
            return const Center(child: Text("No coupons to display"));
          }
        },
      ),
    );
  }
}

import 'package:app/src/config/app_contants.dart';

String formatPrice(num price, [bool showZero = false]) {
  return price > 0
      ? '${AppContants.defaulCurrencyPrefix} ${price.toStringAsFixed(2)}'
      : showZero
          ? "${AppContants.defaulCurrencyPrefix} 0.00"
          : 'Free';
}

import 'package:app/app/config/app_contants.dart';

String formatPrice(num price) {
  return price > 0 ? '${AppContants.defaulCurrencyPrefix} $price' : 'Free';
}

import 'dart:ui';

import 'package:app/app/config/theme_constants.dart';

ColorFilter getPrimaryIconColor() {
  return const ColorFilter.mode(ThemeConstants.primaryColor, BlendMode.srcIn);
}

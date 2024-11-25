import 'dart:ui';

import 'package:app/src/config/theme_constants.dart';

ColorFilter getPrimaryIconColor() {
  return const ColorFilter.mode(ThemeConstants.primaryColor, BlendMode.srcIn);
}

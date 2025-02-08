import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget buildImage(BuildContext context, String courseCoverPicture) {
  return (courseCoverPicture.startsWith('http')
      ? CachedNetworkImage(
          imageUrl: courseCoverPicture,
          width: double.maxFinite,
          fit: BoxFit.fill,
        )
      : Image.file(
          File(courseCoverPicture),
          width: double.maxFinite,
          fit: BoxFit.fill,
        ));
}

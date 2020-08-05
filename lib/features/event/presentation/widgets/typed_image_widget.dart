import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:countdown/core/util/constants.dart';
import 'package:countdown/features/event/models/typed_image.dart';
import 'package:flutter/material.dart';

class TypedImageWidget extends StatelessWidget {
  const TypedImageWidget({Key key, @required this.image}) : super(key: key);
  final TypedImage image;

  @override
  Widget build(BuildContext context) {
    if (image.type == ImageSourceType.network) {
      return CachedNetworkImage(
        imageUrl: image.path,
        fit: BoxFit.cover,
      );
    } else if (image.type == ImageSourceType.gallery) {
      return Image.file(
        File(image.path),
        fit: BoxFit.cover,
      );
    }

    return Image.asset(
      image.path,
      fit: BoxFit.cover,
    );
  }
}

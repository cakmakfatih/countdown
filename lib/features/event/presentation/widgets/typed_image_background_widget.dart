import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:countdown/core/util/constants.dart';
import 'package:countdown/features/event/models/typed_image.dart';
import 'package:flutter/material.dart';

class TypedImageBackgroundWidget extends StatelessWidget {
  const TypedImageBackgroundWidget(
      {Key key, @required this.image, @required this.child})
      : super(key: key);

  final TypedImage image;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (image.type == ImageSourceType.network) {
      imageProvider = CachedNetworkImageProvider(
        image.path,
      );
    } else if (image.type == ImageSourceType.gallery) {
      imageProvider = FileImage(
        File(image.path),
      );
    } else {
      imageProvider = AssetImage(
        image.path,
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}

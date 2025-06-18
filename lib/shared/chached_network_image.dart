import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget networkImage(String url, {double? radius}) {
  return CircleAvatar(
    minRadius: radius ?? 30,
    backgroundImage: CachedNetworkImageProvider(url),
  );
}

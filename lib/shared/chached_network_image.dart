import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget networkImage(String url) {
  return CircleAvatar(
    // minRadius: 25.0,
    backgroundImage: CachedNetworkImageProvider(url),
  );
}

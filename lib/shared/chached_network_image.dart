import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget networkImage(String url) {
  return CachedNetworkImage(
    imageUrl: url,
    imageBuilder: (context, imageProvider) => CircleAvatar(
      radius: 30,
      backgroundImage: imageProvider,
    ),
    placeholder: (context, url) => const SizedBox(
      height: 60.0,
      width: 60.0,
      child: Center(child: CircularProgressIndicator()),
    ),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}

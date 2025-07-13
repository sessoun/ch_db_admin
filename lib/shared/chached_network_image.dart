import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget networkImage(String url, {double? radius}) {
  final size = radius ?? 60;

  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,

        // Reduce memory usage significantly
        memCacheWidth: size.round(),
        memCacheHeight: size.round(),
        maxWidthDiskCache: (size * 1.5).round(),
        maxHeightDiskCache: (size * 1.5).round(),

        // Add filterQuality to reduce processing
        filterQuality: FilterQuality.low,

        placeholder: (context, url) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.person,
            color: Colors.grey[600],
            size: size * 0.5,
          ),
        ),

        errorWidget: (context, url, error) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.broken_image,
            color: Colors.grey[400],
            size: size * 0.5,
          ),
        ),

        // Add fade animation to reduce frame issues
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 100),
      ),
    ),
  );
}

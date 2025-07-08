import 'dart:typed_data';

import 'package:flutter/material.dart';

class CustomImageCard extends StatelessWidget {
  final Uint8List? imageBytes;
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final double elevation;

  const CustomImageCard({
    super.key,
    this.imageBytes,
    this.imageUrl,
    this.width = double.infinity,
    this.height = 160,
    this.fit = BoxFit.cover,
    this.borderRadius = 10,
    this.elevation = 5,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imageBytes != null) {
      imageWidget = Image.memory(
        imageBytes!,
        width: width,
        height: height,
        fit: fit,
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      imageWidget = Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder:
            (context, error, stackTrace) => Container(
              color: Colors.grey.shade200,
              width: width,
              height: height,
              child: const Icon(
                Icons.broken_image,
                size: 40,
                color: Colors.grey,
              ),
            ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey.shade100,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      );
    } else {
      imageWidget = Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
        child: const Icon(Icons.image, size: 40, color: Colors.grey),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Card(elevation: elevation, child: imageWidget),
    );
  }
}

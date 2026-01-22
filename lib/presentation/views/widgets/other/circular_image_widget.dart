import 'dart:io';
import 'package:flutter/material.dart';

/// Reusable circular image widget that supports network, file, and asset images.
/// 
/// Example:
/// ```dart
/// CircularImageWidget(
///   imagePath: 'https://example.com/image.jpg',
///   diameter: 200,
///   width: 300,
/// )
/// ```
class CircularImageWidget extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double diameter;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsets padding;
  final BoxFit fit;

  const CircularImageWidget({
    super.key,
    required this.imagePath,
    required this.diameter,
    this.width,
    this.borderColor = Colors.black26,
    this.borderWidth = 1.0,
    this.padding = const EdgeInsets.all(6.0),
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: Container(
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(200),
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            child: Padding(
              padding: padding,
              child: ClipOval(
                child: _buildImageWidget(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    // Check if it's a network image
    if (imagePath.startsWith('http')) {
      return Image.network(imagePath, fit: fit);
    }
    
    // Check if it's a file path and exists
    if (File(imagePath).existsSync()) {
      return Image.file(File(imagePath), fit: fit);
    }
    
    // Default to asset image
    return Image.asset(imagePath, fit: fit);
  }
}

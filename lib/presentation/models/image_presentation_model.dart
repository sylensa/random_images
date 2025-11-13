import 'package:flutter/material.dart';

/// Presentation model - contains UI-specific data
/// This is where UI concerns like Color belong
class ImagePresentationModel {
  final String imageUrl;
  final Color? backgroundColor;

  const ImagePresentationModel({
    required this.imageUrl,
    this.backgroundColor,
  });

  ImagePresentationModel copyWith({
    String? imageUrl,
    Color? backgroundColor,
  }) {
    return ImagePresentationModel(
      imageUrl: imageUrl ?? this.imageUrl,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}

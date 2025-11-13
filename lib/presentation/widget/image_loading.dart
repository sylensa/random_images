import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageLoading extends StatelessWidget {
  const ImageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return   Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      child: Container(
        width: 200,
        height: 200,
        decoration: const BoxDecoration(
            color: Colors.grey
        ),
      ),
    );

  }
}
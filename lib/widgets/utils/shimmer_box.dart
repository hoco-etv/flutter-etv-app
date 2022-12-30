import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class ShimmerBox extends StatelessWidget {
  final double? aspectRatio;
  final double? height;
  final double? width;
  final Color? baseColor;

  const ShimmerBox(
    {
      this.aspectRatio,
      this.height,
      this.width,
      this.baseColor,
      Key? key
    }
  ) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final baseColor = this.baseColor ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.2);

    return SkeletonLoader(
      builder: Container(
        color: baseColor,
        height: height,
        width: width,
        child: aspectRatio != null ? AspectRatio(aspectRatio: aspectRatio!) : null,
      ),
      highlightColor: Color.alphaBlend(
        Colors.white.withOpacity(0.5),
        baseColor,
      ),
      baseColor: baseColor,
    );
  }
}

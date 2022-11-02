import 'package:flutter/material.dart';

import '/widgets/utils/shimmer_box.dart';

class LoadedNetworkImage extends StatelessWidget {
  final String url;
  final Color? baseColor;
  final double? defaultAspectRatio;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final Map<String, String>? httpHeaders;

  const LoadedNetworkImage(
    this.url,
    {
      this.baseColor,
      this.defaultAspectRatio,
      this.fit,
      this.height,
      this.width,
      this.httpHeaders,
      Key? key
    }
  ) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Image.network(
      url,
      fit: fit,
      height: height,
      width: width,
      headers: httpHeaders,
      frameBuilder: (context, image, frame, loadedSynchronously) =>
        frame != null || loadedSynchronously
          ? image
          : ShimmerBox(aspectRatio: defaultAspectRatio ?? 3/2, baseColor: baseColor),
    );
  }
}

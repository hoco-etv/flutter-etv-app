import 'package:etv_app/widgets/utils/shimmer_box.dart';
import 'package:flutter/material.dart';

class LoadedNetworkImage extends StatelessWidget {
  final String url;
  final Color? baseColor;
  final double? aspectRatio;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final Map<String, String>? httpHeaders;

  const LoadedNetworkImage(
    this.url,
    {
      this.baseColor,
      this.aspectRatio,
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
    return AspectRatio(
      aspectRatio: aspectRatio ?? 3/2,

      child: Image.network(
        url,
        fit: fit,
        height: height,
        width: width,
        headers: httpHeaders,
        frameBuilder: (context, image, frame, loadedSynchronously) =>
          frame != null || loadedSynchronously
            ? image
            : ShimmerBox(aspectRatio: aspectRatio ?? 3/2, baseColor: baseColor),
      )
    );
  }
}

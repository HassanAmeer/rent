import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CacheImageWidget extends StatelessWidget {
  String url;
  int width;
  int height;
  bool isCircle;
  double radius;
  CacheImageWidget({
    super.key,
    this.url = "http://via.placeholder.com/350x150",
    this.width = 100,
    this.height = 100,
    this.radius = 100,
    this.isCircle = true,
  });

  @override
  Widget build(BuildContext context) {
    print(url);
    // return Text("${url}");
    return SizedBox(
      width: width.toDouble(),
      height: height.toDouble(),
      child: isCircle
          ? ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) =>
                    Icon(Icons.image_not_supported),
              ),
            )
          : CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) =>
                  Icon(Icons.image_not_supported),
            ),
    );
  }
}

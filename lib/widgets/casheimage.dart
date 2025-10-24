import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/widgets/dotloader.dart';

class CacheImageWidget extends StatelessWidget {
  String url;
  double width;
  double height;
  bool isCircle;
  double radius;
  BoxFit fit;
  Function? onTap;
  CacheImageWidget({
    super.key,
    this.url = "http://via.placeholder.com/350x150",
    this.width = 100,
    this.height = 100,
    this.radius = 100,
    this.isCircle = true,
    this.fit = BoxFit.cover,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // print(url);
    // return Text("${url}");
    return GestureDetector(
      onTap: onTap == null
          ? null
          : () {
              onTap?.call();
            },
      child: SizedBox(
        width: width.toDouble(),
        height: height.toDouble(),
        child: isCircle
            ? ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: fit,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      DotLoader(showDots: 1),
                  errorWidget: (context, url, error) =>
                      Image.asset(ImgAssets.noImg),
                ),
              )
            : CachedNetworkImage(
                imageUrl: url,
                fit: fit,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    DotLoader(),
                errorWidget: (context, url, error) =>
                    Image.asset(ImgAssets.noImg),
              ),
      ),
    );
  }
}

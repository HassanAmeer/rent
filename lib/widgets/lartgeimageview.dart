import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:rent/constants/scrensizes.dart';
import 'package:rent/main.dart';
import 'package:rent/widgets/casheimage.dart';

LargeImageViewSheet(String imageLink) {
  showModalBottomSheet(
    isDismissible: true,
    isScrollControlled: true, // full screen sheet
    showDragHandle: true,
    barrierColor: Colors.black54,
    context: contextKey.currentState!.context,
    sheetAnimationStyle: AnimationStyle(
      curve: Curves.elasticInOut,
      reverseCurve: Curves.easeInCirc,
      duration: Duration(milliseconds: 300),
    ),
    // constraints: BoxConstraints.expand(),
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return GestureDetector(
        onVerticalDragStart: (details) {
          Navigator.of(context).pop();
        },
        child: SizedBox(
          height: ScreenSize.height * 1,
          child: Center(
            child: InkWell(
              onTapUp: (v) {
                Navigator.pop(context);
              },
              child: Padding(
                // padding: EdgeInsets.only(bottom: ScreenSize.height * 0.15),
                padding: EdgeInsets.only(bottom: 0),
                child: Hero(
                  tag: "123",
                  child: PinchZoom(
                    onZoomEnd: () {},
                    child: CacheImageWidget(
                      url: imageLink,
                      isCircle: false,
                      fit: BoxFit.contain,
                      height: ScreenSize.height * 1,
                      width: ScreenSize.width,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

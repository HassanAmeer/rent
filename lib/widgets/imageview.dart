import 'package:flutter/material.dart';
import '../constants/screensizes.dart';
import 'casheimage.dart';

void showImageView(BuildContext context, String imagelink) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Profileview(imagelink: imagelink),
  );
}

///////////for profileview widget page
class Profileview extends StatefulWidget {
  final String imagelink;
  const Profileview({super.key, required this.imagelink});

  @override
  _ProfileviewState createState() => _ProfileviewState();
}

class _ProfileviewState extends State<Profileview> {
  bool _isZoomed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(200, 0, 0, 0),
      height: ScreenSize.height,
      child: Stack(
        children: [
          // Background tap to dismiss
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.transparent,
              height: ScreenSize.height,
              width: ScreenSize.width,
            ),
          ),
          // Centered image with zoom
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isZoomed = !_isZoomed;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isZoomed ? ScreenSize.height : ScreenSize.height * 0.7,
                width: _isZoomed ? ScreenSize.width : ScreenSize.width,
                child: Hero(
                  tag: "view",
                  child: InteractiveViewer(
                    panEnabled: _isZoomed,
                    scaleEnabled: _isZoomed,
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: CacheImageWidget(
                      url: widget.imagelink,
                      isCircle: false,
                      fit: BoxFit.contain,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

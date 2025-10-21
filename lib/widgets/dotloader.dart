import 'package:flutter/material.dart';
import 'dart:math' as math show sin, pi;
import '../constants/appColors.dart';

/// Enhanced Dot Loader Widget with better customization and performance
class DotLoader extends StatefulWidget {
  const DotLoader({
    super.key,
    this.color = AppColors.mainColor,
    this.size = 27.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1100),
    this.controller,
    this.showDots = 3,
    this.spacing = 5.0,
    this.curve = Curves.easeInOut,
  });

  final int? showDots;
  final Color? color;
  final double size;
  final double spacing;
  final Curve curve;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  State<DotLoader> createState() => _DotLoaderState();
}

class _DotLoaderState extends State<DotLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        (widget.controller ??
              AnimationController(vsync: this, duration: widget.duration))
          ..repeat();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size(widget.size * 2.5, widget.size),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.showDots!, (i) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
              child: ScaleTransition(
                scale: DelayTween(
                  begin: 0.0,
                  end: 1.0,
                  delay: i * .2,
                ).animate(_controller),
                child: SizedBox.fromSize(
                  size: Size.square(widget.size * 0.5),
                  child: _itemBuilder(i),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.8),
                offset: const Offset(-1, -1),
                blurRadius: 2,
              ),
            ],
            color: widget.color,
            shape: BoxShape.circle,
          ),
        );
}

////////////
class DelayTween extends Tween<double> {
  DelayTween({super.begin, super.end, required this.delay});

  final double delay;

  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}

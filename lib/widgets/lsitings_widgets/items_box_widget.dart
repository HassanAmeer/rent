import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rent/constants/tostring.dart';
import 'package:rent/widgets/casheimage.dart';
import '../../constants/appColors.dart';
import '../dotloader.dart';

// ============================================================
//               ULTRA‑AWESOME LISTING CARD
// ============================================================
class ListingBox extends StatefulWidget {
  final String id;
  final String title;
  final String subTitle;
  final String imageUrl;
  final VoidCallback? onTap;
  final bool showDelete;
  final bool isDeleteLoading;
  final VoidCallback? onDeleteTap;
  final bool showCart;
  final bool isCartFilled;
  final bool isCartLoading;
  final VoidCallback? onCartTap;
  final bool showStatusLabel;
  final String statusLabelType;
  // final Color? labelBgColor;
  final bool showFav;
  final bool isFavFilled;
  final bool isFavLoading;
  final VoidCallback? onFavTap;

  const ListingBox({
    super.key,
    required this.id,
    required this.title,
    this.subTitle = "",
    required this.imageUrl,
    this.onTap,
    this.showDelete = false,
    this.isDeleteLoading = false,
    this.onDeleteTap,
    this.showCart = false,
    this.isCartFilled = false,
    this.isCartLoading = false,
    this.onCartTap,
    this.showStatusLabel = false,
    this.statusLabelType = "",
    // this.labelBgColor = const Color.fromARGB(179, 76, 175, 79),
    this.showFav = false,
    this.isFavFilled = false,
    this.isFavLoading = false,
    this.onFavTap,
  });

  @override
  State<ListingBox> createState() => _ListingBoxState();
}

class _ListingBoxState extends State<ListingBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tiltCtrl;
  double _tiltX = 0, _tiltY = 0;

  @override
  void initState() {
    super.initState();
    _tiltCtrl = AnimationController(vsync: this, duration: 300.ms);
  }

  @override
  void dispose() {
    _tiltCtrl.dispose();
    super.dispose();
  }

  void _onPointerMove(PointerMoveEvent e, Size size) {
    final dx = (e.localPosition.dx / size.width) * 2 - 1; // -1 .. 1
    final dy = (e.localPosition.dy / size.height) * 2 - 1;
    setState(() {
      _tiltX = dy * 12; // max tilt 12°
      _tiltY = -dx * 12;
    });
    _tiltCtrl.forward();
  }

  void _onPointerExit(PointerExitEvent _) {
    setState(() => _tiltX = _tiltY = 0);
    _tiltCtrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child:
          MouseRegion(
                onHover: (_) => _tiltCtrl.forward(),
                child: GestureDetector(
                  onTap: widget.isDeleteLoading ? null : widget.onTap,
                  child:
                      AnimatedContainer(
                            duration: 300.ms,
                            curve: Curves.easeOutCubic,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateX(_tiltX * 3.14 / 180)
                              ..rotateY(_tiltY * 3.14 / 180),
                            child: Stack(
                              children: [
                                // ────── GLASS CARD BACKGROUND ──────
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(19),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFF5F7FA),
                                        Color(0xFFE4E9F0),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 30,
                                        offset: const Offset(0, 12),
                                      ),
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.6),
                                        blurRadius: 20,
                                        offset: const Offset(-8, -8),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(19),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 12,
                                        sigmaY: 12,
                                      ),
                                      child: Container(
                                        color: Colors.white.withOpacity(0.15),
                                      ),
                                    ),
                                  ),
                                ),

                                // ────── IMAGE WITH ANIMATED GRADIENT OVERLAY ──────
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(19),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        CacheImageWidget(
                                          url: widget.imageUrl,
                                          fit: BoxFit.cover,
                                          isCircle: false,
                                        ),
                                        // Animated gradient overlay
                                        AnimatedContainer(
                                          duration: 800.ms,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.55),
                                              ],
                                              stops: const [0.4, 1.0],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // ────── TITLE (CENTERED) ──────
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 20,
                                    ),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(24),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          widget.title,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                            color: Colors.white,
                                            height: 1.3,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 8,
                                                color: Colors.black54,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        widget.subTitle
                                                .toString()
                                                .toNullString()
                                                .isEmpty
                                            ? SizedBox.shrink()
                                            : SizedBox(height: 2),
                                        widget.subTitle
                                                .toString()
                                                .toNullString()
                                                .isEmpty
                                            ? SizedBox.shrink()
                                            : Text(
                                                widget.subTitle
                                                    .toString()
                                                    .toNullString(),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 11,
                                                  color: AppColors.mainColor,
                                                  height: 1.3,
                                                  shadows: [
                                                    Shadow(
                                                      blurRadius: 8,
                                                      color: Colors.black54,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                      ],
                                    ),
                                  ),
                                ),

                                // ────── DELETE BUTTON (FLOATING) ──────
                                !widget.showDelete
                                    ? SizedBox.shrink()
                                    : Positioned(
                                        top: 14,
                                        right: 14,
                                        child: GestureDetector(
                                          onTap: widget.isDeleteLoading
                                              ? null
                                              : widget.onDeleteTap,
                                          child: AnimatedContainer(
                                            duration: 250.ms,
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: widget.isDeleteLoading
                                                  ? Colors.red.withOpacity(0.3)
                                                  : Colors.white.withOpacity(
                                                      0.5,
                                                    ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.22),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: widget.isDeleteLoading
                                                ? SizedBox(
                                                    width: 15,
                                                    height: 15,
                                                    child: DotLoader(
                                                      spacing: 0,
                                                      showDots: 1,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : const Icon(
                                                    Icons.delete_outline,
                                                    size: 20,
                                                    color: Color(0xFFE91E63),
                                                  ),
                                          ),
                                        ),
                                      ),

                                !widget.showStatusLabel
                                    ? SizedBox.shrink()
                                    : Positioned(
                                        left: 8,
                                        top: 12,
                                        child: _statusLabel(
                                          widget.statusLabelType.toString(),
                                        ),
                                      ),
                                // ────── fav BUTTON (FLOATING) ──────
                                !widget.showFav
                                    ? SizedBox.shrink()
                                    : Positioned(
                                        top: 14,
                                        right: 14,
                                        child: GestureDetector(
                                          onTap: widget.isFavLoading
                                              ? null
                                              : widget.onFavTap,
                                          child: AnimatedContainer(
                                            duration: 250.ms,
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: widget.isFavLoading
                                                  ? Colors.cyan.withOpacity(0.3)
                                                  : Colors.white.withOpacity(
                                                      0.5,
                                                    ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.22),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: widget.isFavLoading
                                                ? SizedBox(
                                                    width: 15,
                                                    height: 15,
                                                    child: DotLoader(
                                                      spacing: 0,
                                                      showDots: 1,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : Icon(
                                                        widget.isFavFilled
                                                            ? Icons.favorite
                                                            : Icons
                                                                  .favorite_border,
                                                        size: 20,
                                                        color:
                                                            widget.isFavFilled
                                                            ? AppColors
                                                                  .mainColor
                                                            : Colors.black,
                                                      )
                                                      .animate(
                                                        onPlay: (controller) =>
                                                            controller.repeat(),
                                                      )
                                                      .shimmer(
                                                        duration: 2.seconds,
                                                      ),
                                          ),
                                        ),
                                      ),

                                !widget.showCart
                                    ? SizedBox.shrink()
                                    : Positioned(
                                        top: 14,
                                        left: 14,
                                        child: GestureDetector(
                                          onTap: widget.isCartLoading
                                              ? null
                                              : widget.onCartTap,
                                          child: AnimatedContainer(
                                            duration: 250.ms,
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: widget.isCartLoading
                                                  ? Colors.cyan.withOpacity(0.3)
                                                  : Colors.white.withOpacity(
                                                      0.5,
                                                    ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.22),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: widget.isCartLoading
                                                ? SizedBox(
                                                    width: 15,
                                                    height: 15,
                                                    child: DotLoader(
                                                      spacing: 0,
                                                      showDots: 1,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : Icon(
                                                        widget.isCartFilled
                                                            ? Icons
                                                                  .shopping_cart
                                                            : Icons
                                                                  .shopping_cart_outlined,
                                                        size: 20,
                                                        color:
                                                            widget.isCartFilled
                                                            ? AppColors
                                                                  .mainColor
                                                            : Colors.black,
                                                      )
                                                      .animate(
                                                        onPlay: (controller) =>
                                                            controller.repeat(),
                                                      )
                                                      .shimmer(
                                                        duration: 2.seconds,
                                                      ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          )
                          .animate(controller: _tiltCtrl)
                          .scale(
                            begin: Offset(1.0, 1.0),
                            end: Offset(1.1, 1.1),
                            curve: Curves.easeOutBack,
                          ),
                ),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 80.ms)
              .slideY(begin: 0.2, curve: Curves.easeOutCubic),
    );
  }

  Widget _statusLabel(String? status) {
    Color bgColor = Colors.orange;
    String label = "Delivered";

    if (status.toString() == "0") {
      bgColor = Colors.orange.withOpacity(0.5);
      label = "Pending";
    } else if (status.toString() == "1") {
      bgColor = AppColors.mainColor.withOpacity(0.7);
      label = "Rented";
    } else {
      bgColor = Colors.green.withOpacity(0.7);
      label = "Closed";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      ),
    );
  }
}

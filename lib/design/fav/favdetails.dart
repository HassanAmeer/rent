import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/constants/appColors.dart';
import 'package:rent/constants/images.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:rent/constants/screensizes.dart';
import '../../apidata/categoryapi.dart';
import '../../constants/api_endpoints.dart';
import '../../widgets/casheimage.dart';

import '../../models/item_model.dart';
import '../../models/favorite_model.dart';
import '../../widgets/imageview.dart';

class FavDetailsPage extends ConsumerStatefulWidget {
  final FavoriteModel item;

  const FavDetailsPage({super.key, required this.item});

  @override
  _FavDetailsPageState createState() => _FavDetailsPageState();
}

class _FavDetailsPageState extends ConsumerState<FavDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _rotationAnimation = Tween<double>(begin: -0.05, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _bounceAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: const Text(
            "Favourite Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ScaleTransition(
              scale: _bounceAnimation,
              child: CircleAvatar(
                backgroundColor: Colors.black12,
                child: IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Bookmark toggled!")),
                    );
                  },
                  icon: const Icon(Icons.bookmark_added, color: Colors.black87),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[100]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero-wrapped Image with shadow
                    CarouselSlider.builder(
                      itemCount: widget.item.itemImages.length,
                      itemBuilder: (context, index, realIndex) {
                        final imageUrl = widget.item.itemImages[index];
                        return CacheImageWidget(
                          onTap: () {
                            showImageView(context, imageUrl);
                          },
                          width: double.infinity,
                          height: ScreenSize.height * 0.3,
                          isCircle: false,
                          fit: BoxFit.contain,
                          radius: 0,
                          url: imageUrl,
                        );
                      },
                      options: CarouselOptions(
                        height: ScreenSize.height * 0.35,
                        viewportFraction: 0.68,
                        enlargeCenterPage: true,
                        autoPlay: widget.item.itemImages.length > 1,
                        autoPlayInterval: const Duration(seconds: 2),
                        autoPlayAnimationDuration: const Duration(
                          milliseconds: 800,
                        ),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: widget.item.itemImages.length > 1,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Title
                    Text(
                      widget.item.products!.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Description
                    HtmlWidget(
                      widget.item.products!.description!,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ListTile(
                      tileColor: Colors.grey.shade200,
                      contentPadding: EdgeInsets.only(left: 5),

                      leading: CacheImageWidget(
                        width: 25,
                        height: 25,
                        isCircle: true,
                        radius: 5,
                        url:
                            "${widget.item.products!.category != null
                                ? ref.watch(categoryProvider).categories.where((e) => e.id == widget.item.products!.category).isNotEmpty
                                      ? ref.watch(categoryProvider).categories.firstWhere((e) => e.id == widget.item.products!.category).image
                                      : null
                                : null}",
                      ),
                      title: Text(
                        "${widget.item.products!.category != null
                            ? ref.watch(categoryProvider).categories.where((e) => e.id == widget.item.products!.category).isNotEmpty
                                  ? ref.watch(categoryProvider).categories.firstWhere((e) => e.id == widget.item.products!.category).name
                                  : null
                            : null}",
                      ),
                      trailing: Text("Category  "),
                    ),
                    // Rates Section with Staggered Animation
                    RotationTransition(
                      turns: _rotationAnimation,
                      child: _buildRatesCard(context),
                    ),
                    const SizedBox(height: 5),
                    // Other Details
                    Card(
                      color: AppColors.shimmerHighlightColor,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildDetailRow(
                          context,
                          "Availability Days",

                          widget.item.products!.availabilityDays ?? 'N/A',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const SizedBox(height: 16),
                    // User Section
                    const Text(
                      "Product By",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ScaleTransition(
                      scale: _bounceAnimation,
                      child: ListTile(
                        leading: CacheImageWidget(
                          width: 50,
                          height: 50,
                          isCircle: true,
                          radius: 200,
                          url: widget.item.rentalusers!.fullImageUrl,
                        ),
                        title: Text(
                          widget.item.rentalusers!.name,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          widget.item.rentalusers!.email,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    const Divider(),
                    _buildDetailRow(
                      context,
                      "Listing Date",

                      widget.item.createdAt?.toString() ?? 'N/A',
                    ),
                    const Divider(),
                    // _buildDetailRow(
                    //   context,
                    //   "Updated At",
                    //   widget.fullData['updated_at'] ?? 'N/A',
                    // )
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatesCard(BuildContext context) {
    final rates = [
      {
        'label': 'Daily Rate',
        'value': widget.item.formattedDailyRate,
        'icon': Icons.calendar_today,
      },
      {
        'label': 'Weekly Rate',
        'value': widget.item.products!.formattedWeeklyRate,
        'icon': Icons.date_range,
      },
      {
        'label': 'Monthly Rate',
        'value': widget.item.products!.formattedMonthlyRate,
        'icon': Icons.event,
      },
    ];

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(rates.length, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                      0.2 + (index * 0.2), // Staggered delay
                      0.8 + (index * 0.2),
                      curve: Curves.bounceOut,
                    ),
                  ),
                );
                return Opacity(
                  opacity: animation.value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - animation.value)),
                    child: _buildRateRow(
                      context,
                      rates[index]['label'] as String,
                      rates[index]['value'] as String,
                      rates[index]['icon'] as IconData,
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildRateRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blueAccent, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}

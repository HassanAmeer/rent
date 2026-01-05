import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/constants/appColors.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/constants/tostring.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rent/widgets/dotloader.dart';
import 'package:rent/widgets/imageview.dart';

import '../../constants/api_endpoints.dart';
import '../../constants/screensizes.dart';
import '../../models/blog_model.dart';
import '../../apidata/blogapi.dart';

class Blogsdetails extends ConsumerStatefulWidget {
  final int index;
  const Blogsdetails({super.key, required this.index});

  @override
  ConsumerState<Blogsdetails> createState() => _BlogsdetailsState();
}

class _BlogsdetailsState extends ConsumerState<Blogsdetails> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final blog = ref.watch(blogDataProvider).blogs[widget.index];

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.white, AppColors.mainColor.shade100],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   title: const Text(
        //     "Blog Details",
        //     style: TextStyle(
        //       color: Colors.white,
        //       fontWeight: FontWeight.bold,
        //       fontSize: 20,
        //     ),
        //   ),
        //   backgroundColor: AppColors.mainColor,
        //   elevation: 0,
        //   iconTheme: const IconThemeData(color: Colors.white),
        // ),
        body: isLoading
            ? Center(
                child: SizedBox(
                  height: ScreenSize.height * 0.6,
                  child: DotLoader(),
                ),
              ).animate().fadeIn(duration: Duration(milliseconds: 500)).scale()
            : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            "Blog Details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      // ✅ Blog Image with Text Overlay
                      Container(
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.mainColor.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                children: [
                                  // Background Image - Full size
                                  Positioned.fill(
                                    child: CacheImageWidget(
                                      url: blog.image,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      isCircle: false,
                                      onTap: () {
                                        showImageView(context, blog.image);
                                      },
                                    ),
                                  ),

                                  // Gradient Overlay for better text readability
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            AppColors.mainColor.withOpacity(
                                              0.8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Text Overlay - Better positioning
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    right: 20,
                                    child: SafeArea(
                                      child: Text(
                                        blog.title,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          height: 1.3,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(2, 2),
                                              blurRadius: 4,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: GestureDetector(
                                      onTap: () {
                                        showImageView(context, blog.image);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .animate()
                          .fadeIn(
                            delay: Duration(milliseconds: 300),
                            duration: Duration(milliseconds: 800),
                          )
                          .slideY(begin: -0.1),
                      const SizedBox(height: 15),
                      ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              const Text(
                                "Description",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // ✅ HTML Widget for rich text content
                              blog.content.toString().toNullString().isEmpty
                                  ? const Text(
                                      "No description available",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        height: 1.6,
                                      ),
                                    )
                                  : HtmlWidget(
                                      blog.content,
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        height: 1.6,
                                      ),
                                    ),
                            ],
                          )
                          .animate()
                          .fadeIn(
                            delay: Duration(milliseconds: 500),
                            duration: Duration(milliseconds: 800),
                          )
                          .slideY(begin: 0.1),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

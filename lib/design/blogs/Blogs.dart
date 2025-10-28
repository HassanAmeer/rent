import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_widgets/widgets/tiktok.dart';
import 'package:rent/constants/appColors.dart';
import 'package:rent/apidata/blogapi.dart' show blogDataProvider;
import 'package:rent/services/goto.dart';
import 'package:rent/constants/screensizes.dart';
import 'package:rent/design/blogs/blogsdetails.dart';
import 'package:rent/widgets/dotloader.dart';

import '../../constants/api_endpoints.dart';
import '../../constants/images.dart';
import '../../widgets/casheimage.dart';
import '../../models/blog_model.dart';

class Blogs extends ConsumerStatefulWidget {
  const Blogs({super.key});

  @override
  ConsumerState<Blogs> createState() => _BlogsState();
}

class _BlogsState extends ConsumerState<Blogs> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(blogDataProvider).fetchAllBlogs(loadingFor: "blogs");
    });
  }

  @override
  Widget build(BuildContext context) {
    final blogProvider = ref.watch(blogDataProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          "My Blogs",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.mainColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(blogDataProvider)
              .fetchAllBlogs(refresh: true, loadingFor: "refresh");
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              blogProvider.loadingFor == "refresh"
                  ? Container(
                      height: 60,
                      child: QuickTikTokLoader(
                        progressColor: AppColors.mainColor,
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ).animate().fadeIn(duration: Duration(milliseconds: 300))
                  : SizedBox.shrink(),

              blogProvider.loadingFor == "blogs"
                  ? Center(
                          child: Container(
                            padding: EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.mainColor.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DotLoader(),
                                SizedBox(height: 16),
                                Text(
                                  "Loading blogs...",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(duration: Duration(milliseconds: 500))
                        .scale()
                  : blogProvider.blogs.isEmpty
                  ? Center(
                          child: Container(
                            padding: EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.mainColor.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.article_outlined,
                                  size: 80,
                                  color: AppColors.mainColor,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "No Blogs Found",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "No blog posts available at the moment",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(
                          delay: Duration(milliseconds: 500),
                          duration: Duration(milliseconds: 800),
                        )
                        .scale()
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.65,
                          ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: blogProvider.blogs.length,
                      itemBuilder: (context, index) {
                        final blog = blogProvider.blogs[index];

                        return GestureDetector(
                          onTap: () {
                            goto(Blogsdetails(index: index));
                          },
                          child:
                              Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.mainColor
                                              .withOpacity(0.1),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: AppColors.mainColor.withOpacity(
                                          0.1,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // ✅ Image section
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: Colors.grey.shade100,
                                              border: Border.all(
                                                color: AppColors.mainColor
                                                    .withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: CacheImageWidget(
                                                onTap: () {
                                                  goto(
                                                    Blogsdetails(index: index),
                                                  );
                                                },
                                                isCircle: false,
                                                fit: BoxFit.cover,
                                                url: blog.image,
                                                height: double.infinity,
                                                width: double.infinity,
                                              ),
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Text(
                                              blog.displayTitle,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(
                                    delay: Duration(milliseconds: index * 150),
                                    duration: Duration(milliseconds: 600),
                                  )
                                  .slideY(begin: 0.2),
                        );
                      },
                    ).animate().fadeIn(
                      delay: Duration(milliseconds: 500),
                      duration: Duration(milliseconds: 800),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

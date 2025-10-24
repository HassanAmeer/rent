import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_widgets/widgets/tiktok.dart';
import 'package:rent/apidata/blogapi.dart' show blogDataProvider;
import 'package:rent/constants/goto.dart';
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
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          "My Blogs",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
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
                  ? QuickTikTokLoader(
                      progressColor: Colors.black,
                      backgroundColor: Colors.grey,
                    )
                  : SizedBox.shrink(),
              blogProvider.loadingFor == "blogs"
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 250),
                        child: DotLoader(),
                      ),
                    )
                  : blogProvider.blogs.isEmpty
                  ? const Center(child: Text("No blogs found"))
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 0.65, // ✅ thoda lamba card
                          ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: blogProvider.blogs.length,
                      itemBuilder: (context, index) {
                        final blog = blogProvider.blogs[index];

                        return GestureDetector(
                          onTap: () {
                            goto(Blogsdetails(blog: blog));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ✅ Image section
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CacheImageWidget(
                                  onTap: () {
                                    goto(Blogsdetails(blog: blog));
                                  },
                                  isCircle: false,
                                  url: blog.image,
                                  height: ScreenSize.height * 0.24,
                                  width: ScreenSize.width,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // ✅ Title
                              Text(
                                blog.displayTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),

                              const SizedBox(height: 4),
                            ],
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

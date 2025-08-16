import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/apidata/blogapi.dart' show blogDataProvider;
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/scrensizes.dart';
import 'package:rent/design/blogs/blogsdetails.dart';
import 'package:rent/widgets/dotloader.dart';

import '../../constants/data.dart';
import '../../widgets/casheimage.dart';

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
      ref.read(blogDataProvider).fetchAllBlogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final blogProvider = ref.watch(blogDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "My Blogs",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: blogProvider.isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 200),
                child: DotLoader(),
              ),
            )
          : blogProvider.blogs.isEmpty
          ? const Center(child: Text("No blogs found"))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65, // ✅ thoda lamba card
              ),
              itemCount: blogProvider.blogs.length,
              itemBuilder: (context, index) {
                final blog = blogProvider.blogs[index];
                final imageUrl = blog['image'];

                return InkWell(
                  onTap: () {
                    goto(Blogsdetails(blog: blogProvider.blogs[index]));
                    // ✅ Yahan aap apna next page call karo
                    // Example:
                    // Navigator.push(context, MaterialPageRoute(
                    //   builder: (_) => BlogDetailPage(blog: blog),
                    // ));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ Image section
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CacheImageWidget(
                          isCircle: false,
                          url: imageUrl != null && imageUrl.isNotEmpty
                              ? Config.imgUrl + imageUrl
                              : ImgLinks.product,
                          height: (ScreenSize.height * 0.25).toInt(),
                          width: ScreenSize.width.toInt(),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ✅ Title
                      Text(
                        blog['title'] ?? "No Title",
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
    );
  }
}

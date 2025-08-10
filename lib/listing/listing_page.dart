import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/apidata/listingapi.dart';
import 'package:rent/apidata/user.dart';
import 'package:rent/constants/data.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/listing/ListingDetailPage.dart';
import 'package:rent/listing/add_new_listing_page.dart';
import 'package:rent/constants/scrensizes.dart';
import 'package:rent/listing/listing_edit_page.dart';
import 'package:rent/widgets/btmnavbar.dart';
import '../home_page.dart';

class ListingPage extends ConsumerStatefulWidget {
  const ListingPage({super.key});

  @override
  ConsumerState<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends ConsumerState<ListingPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      ref
          .watch(listingDataProvider)
          .fetchMyItems(
            uid: ref.watch(userDataClass).userdata["id"].toString(),
          );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
        ),
        title: const Text(
          "My Listings",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            /// Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  border: InputBorder.none,
                  hintText: 'Search Listings...',
                ),
              ),
            ),
            const SizedBox(height: 25),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: ref.watch(listingDataProvider).listings.length,
                itemBuilder: (context, index) {
                  final item = ref.watch(listingDataProvider).listings[index];
                  return GestureDetector(
                    onTap: () {
                      goto(ListingDetailPage(fullData: item));
                    },
                    child: ListingBox(
                      id: ref
                          .watch(listingDataProvider)
                          .listings[index]['id']
                          .toString(),
                      title:
                          ref
                              .watch(listingDataProvider)
                              .listings[index]['title'] ??
                          'No Name',
                      imageUrl:
                          Config.imgUrl +
                              ref
                                  .watch(listingDataProvider)
                                  .listings[index]['images'][0] ??
                          imgLinks.product, // ✅ Image from API
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      /// Floating Add Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditListingPage()),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      /// Bottom Navigation
      bottomNavigationBar: BottomNavBarWidget(currentIndex: 1),
    );
  }
}

class ListingBox extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  const ListingBox({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Main Box
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              /// Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: Image.network(
                  imageUrl,
                  height: ScreenSize.height * 0.12,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 50),
                ),
              ),
              const SizedBox(height: 20),

              /// Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),

        /// Edit/Delete Icons
        Positioned(
          top: 5,
          left: 5,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditListingPage(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 16, color: Colors.blue),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  // TODO: Delete action
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete, size: 16, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

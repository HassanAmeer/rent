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
                  childAspectRatio: 0.75,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
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
                          imgLinks.product,
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
            MaterialPageRoute(builder: (context) => const AddNewListingPage()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 11, 11, 11),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

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
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image container with expanded height
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
              flex: 4,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 40),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Add delete functionality
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Listing'),
                            content: const Text(
                              'Are you sure you want to delete this listing?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: Implement delete logic
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                            255,
                            238,
                            236,
                            236,
                          ).withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete,
                          size: 18,
                          color: Color.fromARGB(255, 193, 16, 4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Text container with reduced height
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

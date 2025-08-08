import 'package:flutter/material.dart';
import 'package:rent/constants/data.dart';
import 'package:rent/add_new_listing_page.dart';
import 'package:rent/constants/scrensizes.dart';
import 'package:rent/listing_edit_page.dart';
import 'package:rent/api_service.dart';
import 'package:rent/listing_detail_page.dart'; // ✅ Detail page import
import 'package:rent/widgets/btmnavbar.dart';
import 'home_page.dart';
// ✅ Make sure this file exists
// Already present

class ListingPage extends StatelessWidget {
  const ListingPage({super.key});

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

            /// Listings Grid from API
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: ApiService.fetchListings(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Center(child: Text('No listings found.'));
                  }

                  final listings = snapshot.data!;

                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.15,
                    children: listings.map((listing) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ListingDetailPage(data: listing),
                            ),
                          );
                        },

                        child: ListingBox(
                          id: listing['id'].toString(),
                          title: listing['firstName'] ?? 'No Name',
                          imageUrl: imgLinks.product,
                          // imageUrl: listing['image'] ?? '${imgLinks.product}',
                        ),
                      );
                    }).toList(),
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

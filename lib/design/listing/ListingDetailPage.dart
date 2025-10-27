import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/constants/images.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:rent/constants/screensizes.dart';
import 'package:rent/models/item_model.dart';
import 'package:transparent_route/transparent_route.dart';

import '../../apidata/categoryapi.dart';
import '../../apidata/listingapi.dart';
import '../../widgets/casheimage.dart';
import '../../widgets/imageview.dart' show showImageView;
import 'listing_edit_page.dart'; // ✅ Edit page import

class ListingDetailPage extends ConsumerStatefulWidget {
  final int index;

  const ListingDetailPage({super.key, required this.index});

  @override
  ConsumerState<ListingDetailPage> createState() => _ListingDetailPageState();
}

class _ListingDetailPageState extends ConsumerState<ListingDetailPage> {
  @override
  Widget build(BuildContext context) {
    final item = ref.watch(listingDataProvider).listings[widget.index];
    return Scaffold(
      appBar: AppBar(title: const Text("listing Details")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider.builder(
                itemCount: item.images.length,
                itemBuilder: (context, index, realIndex) {
                  final imageUrl = item.images[index];
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
                  autoPlay: item.images.length > 1,
                  autoPlayInterval: const Duration(seconds: 2),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: item.images.length > 1,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              const SizedBox(height: 15),

              Text(
                item.displayTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),
              HtmlWidget(item.description ?? 'No description available'),
              const SizedBox(height: 15),

              ListTile(
                tileColor: Colors.grey.shade200,
                contentPadding: EdgeInsets.only(left: 5),

                leading: CacheImageWidget(
                  width: 25,
                  height: 25,
                  isCircle: true,
                  radius: 5,
                  url:
                      "${item.categoryId != null
                          ? ref.watch(categoryProvider).categories.where((e) => e.id == item.categoryId).isNotEmpty
                                ? ref.watch(categoryProvider).categories.firstWhere((e) => e.id == item.categoryId).image
                                : null
                          : null}",
                ),
                title: Text(
                  "${item.categoryId != null
                      ? ref.watch(categoryProvider).categories.where((e) => e.id == item.categoryId).isNotEmpty
                            ? ref.watch(categoryProvider).categories.firstWhere((e) => e.id == item.categoryId).name
                            : null
                      : null}",
                ),
                trailing: Text("Category  "),
              ),
              // Divider(height: 1, color: Colors.grey.shade300),
              ListTile(
                contentPadding: EdgeInsets.only(left: 0),
                title: Text(
                  "Availability: ",
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  style: TextStyle(color: Colors.grey),
                  item.availabilityDays ?? 'Not specified',
                ),
              ),
              Divider(),

              ListTile(title: Text("Daily Rate: ${item.formattedDailyRate}")),
              Divider(),
              ListTile(title: Text("Weekly Rate: ${item.formattedWeeklyRate}")),
              Divider(),
              ListTile(
                title: Text("Monthly Rate: ${item.formattedMonthlyRate}"),
              ),

              Divider(),

              const ListTile(title: Text("Listing By")),
              if (item.user != null) ...[
                ListTile(
                  leading: CacheImageWidget(
                    width: 50,
                    height: 50,
                    isCircle: true,
                    radius: 200,
                    url: item.user!.fullImageUrl.isNotEmpty
                        ? item.user!.fullImageUrl
                        : ImgLinks.profileImage,
                  ),
                  title: Text(item.user!.displayName),
                  subtitle: Text(item.user!.email),
                ),
              ] else ...[
                const ListTile(
                  leading: Icon(Icons.account_circle, size: 50),
                  title: Text("User information not available"),
                ),
              ],
              Divider(),
              ListTile(
                minVerticalPadding: 2,
                title: Text(
                  "Listing At: ${item.createdAt?.toString() ?? 'N/A'}",
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              SizedBox(height: 70),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "editListing",
        child: const Icon(Icons.edit),

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditListingPage(item: item),
            ),
          );
        },
      ),
    );
  }
}

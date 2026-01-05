import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/constants/appColors.dart';
import 'package:rent/constants/images.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:rent/constants/screensizes.dart';
import 'package:rent/models/item_model.dart';
import 'package:rent/widgets/item_content_details_widget.dart';
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
    final listingData = ref.watch(listingDataProvider).listings[widget.index];
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, AppColors.mainColor.shade50],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          title: const Text(
            "Listing Details",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Stack(
          children: [
            ItemContentDetailsWidget(
              images: listingData.images,
              title: listingData.displayTitle,
              description: listingData.description,
              catgName:
                  "${listingData.categoryId != null
                      ? ref.watch(categoryProvider).categories.where((e) => e.id == listingData.categoryId).isNotEmpty
                            ? ref.watch(categoryProvider).categories.firstWhere((e) => e.id == listingData.categoryId).name
                            : null
                      : null}",
              catgImg:
                  "${listingData.categoryId != null
                      ? ref.watch(categoryProvider).categories.where((e) => e.id == listingData.categoryId).isNotEmpty
                            ? ref.watch(categoryProvider).categories.firstWhere((e) => e.id == listingData.categoryId).image
                            : null
                      : null}",
              dailyRate: listingData.dailyRate.toString(),
              weeklyRate: listingData.weeklyRate.toString(),
              monthlyRate: listingData.monthlyRate.toString(),
              availability: listingData.availabilityRange,
              listingDate: listingData.createdAt.toString(),
              // orderDate: orderDate,
              userImage: listingData.user?.image,
              userName: listingData.user?.name,
              userEmail: listingData.user?.email,
              userPhone: listingData.user?.phone,
              userAddress: listingData.user?.address,
              userAbout: listingData.user?.aboutUs,
              // onBookNowTap: (){},
            ),
            Positioned(
              left: 10,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: const Offset(0, 0),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "editListing",
          child: const Icon(Icons.edit),

          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditListingPage(item: listingData),
              ),
            );
          },
        ),
      ),
    );
  }
}

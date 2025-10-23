import 'package:flutter/material.dart';
import 'package:rent/constants/images.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:rent/constants/screensizes.dart';
import 'package:rent/models/item_model.dart';

import '../../widgets/casheimage.dart';
import 'listing_edit_page.dart'; // ✅ Edit page import

class ListingDetailPage extends StatelessWidget {
  final ItemModel item;

  const ListingDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("listing Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CacheImageWidget(
                    width: double.infinity,
                    height: ScreenSize.height * 0.4,
                    isCircle: false,
                    fit: BoxFit.contain,
                    radius: 0,
                    url: item.primaryImageUrl.isNotEmpty
                        ? item.primaryImageUrl
                        : ImgLinks.product,
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Text(
                item.displayTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),
              HtmlWidget(item.description ?? 'No description available'),

              Divider(),

              ListTile(title: Text("Daily Rate: ${item.formattedDailyRate}")),
              Divider(),
              ListTile(title: Text("Weekly Rate: ${item.formattedWeeklyRate}")),
              Divider(),
              ListTile(
                title: Text("Monthly Rate: ${item.formattedMonthlyRate}"),
              ),
              Divider(),
              ListTile(
                title: Text("Created: ${item.createdAt?.toString() ?? 'N/A'}"),
              ),
              Divider(),
              ListTile(
                title: Text("Updated: ${item.updatedAt?.toString() ?? 'N/A'}"),
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Availability: ${item.availabilityDays ?? 'Not specified'}",
                ),
              ),
              Divider(),

              const ListTile(title: Text("From User")),
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

import 'package:flutter/material.dart';
import 'package:rent/constants/images.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:rent/constants/scrensizes.dart';

import '../../widgets/casheimage.dart';
import '../../models/item_model.dart';
// ✅ Edit page import

class Allitemdetailspage extends StatelessWidget {
  final ItemModel item;

  const Allitemdetailspage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Item Details")),
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
                    url: item.primaryImageUrl.isNotEmpty
                        ? item.primaryImageUrl
                        : ImgLinks.profileImage,
                  ),
                ],
              ),

              const SizedBox(height: 10),

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

              // Item owner information
              if (item.user != null) ...[
                const ListTile(title: Text("From User")),
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
              ],
            ],
          ),
        ),
      ),
    );
  }
}

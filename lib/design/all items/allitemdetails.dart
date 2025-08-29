import 'package:flutter/material.dart';
import 'package:rent/constants/images.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:rent/constants/scrensizes.dart';
import 'package:rent/models/allItemsModel.dart';

import '../../widgets/casheimage.dart';
// ✅ Edit page import

class Allitemdetailspage extends StatelessWidget {
  final AllItemsModel fullData;

  const Allitemdetailspage({super.key, required this.fullData});

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
                    url: Config.imgUrl + fullData.images.first,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                "${fullData.title}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),
              HtmlWidget(fullData.description),

              Divider(),

              ListTile(title: Text("dailyrate: ${fullData.deletedAt}")),
              Divider(),
              ListTile(title: Text("weeklyrate: ${fullData.weeklyrate}")),
              Divider(),
              ListTile(title: Text(" monthlyrate: ${fullData.monthlyrate}")),
              Divider(),
              ListTile(title: Text("created_at: ${fullData.createdAt}")),
              Divider(),
              ListTile(title: Text(" updated_at: ${fullData.updatedAt}")),
              Divider(),
              ListTile(
                title: Text(" availabilityDays: ${fullData.availabilityDays}"),
              ),
              Divider(),

              // Text("$fullData"),
              const ListTile(title: Text("From User")),
              ListTile(
                leading: CacheImageWidget(
                  width: 50,
                  height: 50,
                  isCircle: true,
                  radius: 200,
                  url: Config.imgUrl + fullData.images[0],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

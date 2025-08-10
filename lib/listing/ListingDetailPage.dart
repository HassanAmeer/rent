import 'package:flutter/material.dart';
import 'package:rent/constants/data.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../widgets/casheimage.dart';

class ListingDetailPage extends StatelessWidget {
  final Map<String, dynamic> fullData;

  const ListingDetailPage({super.key, required this.fullData});

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
              CacheImageWidget(
                width: 300,
                height: 150,
                isCircle: false,
                radius: 0,
                url:
                    Config.imgUrl + fullData['images'][0] ??
                    imgLinks.profileImage,
              ),

              Text(
                "${fullData['title'] ?? 'Title.......'}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),
              // Text(
              //   "${fullData['desc'] ?? 'Description.......'}",
              //   style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
              // ),
              HtmlWidget(fullData['description'] ?? 'Description.......'),

              Divider(),

              ListTile(
                title: Text("dailyrate: ${fullData['dailyrate'] ?? '0'}"),
              ),
              Divider(),
              ListTile(
                title: Text("weeklyrate: ${fullData['weeklyrate'] ?? '0'}"),
              ),
              Divider(),
              ListTile(
                title: Text(" monthlyrate: ${fullData['monthlyrate'] ?? '0'}"),
              ),
              Divider(),
              ListTile(
                title: Text("created_at: ${fullData['created_at'] ?? '0'}"),
              ),
              Divider(),
              ListTile(
                title: Text(" updated_at: ${fullData[' updated_at'] ?? '0'}"),
              ),
              Divider(),
              ListTile(
                title: Text(
                  " availabilityDays: ${fullData['availabilityDays'] ?? '0'}",
                ),
              ),
              Divider(),

              ListTile(title: Text("From User")),
              ListTile(
                leading: CacheImageWidget(
                  width: 50,
                  height: 50,
                  isCircle: true,
                  radius: 200,
                  url:
                      Config.imgUrl + fullData['images'][0] ??
                      imgLinks.profileImage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

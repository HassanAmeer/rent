import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/data.dart';
import '../widgets/casheimage.dart';

class Bookindetails extends ConsumerStatefulWidget {
  const Bookindetails({super.key});

  @override
  ConsumerState<Bookindetails> createState() => _BookindetailsState();
}

class _BookindetailsState extends ConsumerState<Bookindetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Booking Details")),
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
                    width: 300,
                    height: 150,
                    isCircle: false,
                    radius: 0,
                    url:
                        Config.imgUrl + fullData['images'][0] ??
                        imgLinks.profileImage,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                "${fullData['title'] ?? 'Title.......'}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),
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

              const ListTile(title: Text("From User")),
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
      floatingActionButton: FloatingActionButton(
        heroTag: "editListing",
        child: const Icon(Icons.edit),

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditListingPage(itemData: fullData),
            ),
          );
        },
      ),
    );
  }
}

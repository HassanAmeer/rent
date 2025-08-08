import 'package:flutter/material.dart';
import 'package:rent/constants/data.dart' hide AppAssets, ImagesLinks;
import 'package:rent/auth/profile_details_page.dart';
import 'package:rent/temp/data.dart' show ImagesLinks, AppAssets;

class NotificationsDetails extends StatefulWidget {
  const NotificationsDetails({super.key});

  set notify(List notify) {}

  @override
  State<NotificationsDetails> createState() => _NotificationsDetailsState();
}

class _NotificationsDetailsState extends State<NotificationsDetails> {
  final List<Map<String, dynamic>> notifications = [
    // Your existing notification data remains unchanged
    {
      "name": "Ashley",
      "image": "https://randomuser.me/api/portraits/women/1.jpg",
      "item": "Vintage Type Writer",
      "itemImage":
          "https://deepseek-api-files.obs.cn-east-3.myhuaweicloud.com/raw/2025/07/29/file-1b1ea6e8-45a3-4372-ab58-dd577f1c49e9?response-content-disposition=attachment%3B+filename%3D%22Screenshot+2025-07-28+231949.png%22&AccessKeyId=OD83TSXECLFQNNSZ3IF6&Expires=1753872898&Signature=bMaKv%2B8g7yF4RH4pZ9ISg%2BP9xIA%3D",
      "availability": "sadf",
      "pickupDates": "",
    },
    {
      "name": "Ashley",
      "image": "https://randomuser.me/api/portraits/women/1.jpg",
      "item": "Vintage Type Writer",
      "itemImage":
          "https://deepseek-api-files.obs.cn-east-3.myhuaweicloud.com/raw/2025/07/29/file-1b1ea6e8-45a3-4372-ab58-dd577f1c49e9?response-content-disposition=attachment%3B+filename%3D%22Screenshot+2025-07-28+231949.png%22&AccessKeyId=OD83TSXECLFQNNSZ3IF6&Expires=1753872898&Signature=bMaKv%2B8g7yF4RH4pZ9ISg%2BP9xIA%3D",
      "availability": "sadf",
      "pickupDates": "",
    },
    {
      "name": "Ashley",
      "image": "https://randomuser.me/api/portraits/women/1.jpg",
      "item": "kayake",
      "itemImage":
          "https://deepseek-api-files.obs.cn-east-3.myhuaweicloud.com/raw/2025/07/29/file-b4caa768-4037-46d4-8ee7-c6c6eb7506c9?response-content-disposition=attachment%3B+filename%3D%22Screenshot+2025-07-28+232044.png%22&AccessKeyId=OD83TSXECLFQNNSZ3IF6&Expires=1753873063&Signature=msGZ3VYzduzIvl4pGkv3hpsH0uA%3D",
      "availability": "1",
      "pickupDates": "",
    },
    // Other items...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Image.asset(AppAssets.logo, width: 80), // Reduced from 100
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileDetailsPage()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.cyan.shade700,
                borderRadius: BorderRadius.circular(4),
              ),
              width: 30, // Reduced from 35
              height: 30, // Reduced from 35
              child: Image.network(
                ImagesLinks.profileImage,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 18,
                ), // Smaller icon
              ),
            ),
          ),
          const SizedBox(width: 12), // Reduced from 16
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8), // Reduced top padding
            child: Center(
              child: Text(
                "Notifications Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ), // Reduced from 18
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12), // Reduced from 16
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12), // Reduced from 16
                  child: Padding(
                    padding: const EdgeInsets.all(12), // Reduced from 16
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User profile with name (smaller)
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18, // Reduced from 20
                              backgroundImage: NetworkImage(item['image']),
                            ),
                            const SizedBox(width: 10), // Reduced from 12
                            Text(
                              item['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15, // Reduced from 16
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12), // Reduced from 16
                        // Item name with image (smaller)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 70, // Reduced from 80
                              height: 70, // Reduced from 80
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  6,
                                ), // Reduced from 8
                                image: DecorationImage(
                                  image: NetworkImage(item['itemImage']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10), // Reduced from 12
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['item'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15, // Reduced from 16
                                    ),
                                  ),
                                  const SizedBox(height: 6), // Reduced from 8
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style
                                          .copyWith(
                                            fontSize: 13,
                                          ), // Smaller text
                                      children: [
                                        const TextSpan(text: "Availability: "),
                                        TextSpan(
                                          text: item['availability'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ), // Reduced from 4 (same)
                                  const Text(
                                    "Pickup Dates:",
                                    style: TextStyle(fontSize: 13),
                                  ), // Smaller
                                  if (item['pickupDates'].isNotEmpty)
                                    Text(
                                      item['pickupDates'],
                                      style: const TextStyle(fontSize: 13),
                                    ), // Smaller
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12), // Reduced from 16
                        // View button (smaller)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ), // Smaller
                            ),
                            onPressed: () {},
                            child: const Text(
                              "View",
                              style: TextStyle(fontSize: 14),
                            ), // Smaller
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

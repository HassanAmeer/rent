import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/apidata/notifyData.dart';
import 'package:rent/apidata/user.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/scrensizes.dart';
import 'package:rent/constants/notificationsdetails.dart';
import 'package:rent/auth/profile_details_page.dart';
import 'package:rent/temp/data.dart';

import '../constants/data.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<NotificationPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .watch(notifyData)
          .getNotifyData(
            uid: ref.watch(userDataClass).userdata['id'].toString(),
          );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Image.asset(AppAssets.logo, width: 100),

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
              width: 35,
              height: 35,
              clipBehavior: Clip.antiAlias,
              child: Image.network(ImagesLinks.profileImage, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "Notification Users",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          ref.watch(notifyData).isLoading == true
              ? Center(child: CircularProgressIndicator.adaptive())
              : ref.watch(notifyData).notify.isEmpty
              ? Center(child: Text("Notifications Empty"))
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: ref.watch(notifyData).notify.length,
                    itemBuilder: (context, index) {
                      final item = ref.watch(notifyData).notify[index];
                      return GestureDetector(
                        onTap: () {
                          goto(NotificationsDetails(fullData: item));
                        },
                        child: Container(
                          height: ScreenSize.height * 0.23,

                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: Image.network(
                                      Config.imgUrl + item['fromuid']['image']!,
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.cyan,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.notifications,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title']! ?? "Empty",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Text(item['desc']! ?? "Empty"),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        // Text(
                                        //   item['desc']! ?? "Empty",
                                        //   style: const TextStyle(
                                        //     fontSize: 12,
                                        //     color: Colors.grey,
                                        //   ),
                                        // ),
                                        const SizedBox(width: 8),
                                        Text(
                                          item['created_at']! ?? "Empty",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  // _deleteNotification(index);
                                },
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

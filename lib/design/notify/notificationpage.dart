import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:rent/constants/goto.dart';
import 'package:rent/constants/screensizes.dart';
import 'package:rent/design/notify/notificationsdetails.dart';
import 'package:rent/Auth/profile_details_page.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';
// import 'package:rent/temp/data.dart';
import '../../constants/api_endpoints.dart';
import '../../constants/images.dart';
import '../../apidata/notifyData.dart';
import '../../apidata/user.dart';
import '../../models/notification_model.dart';

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
            loadingFor: "fetchNotifyData",
            uid: ref.watch(userDataClass).userId,
          );
    });
    super.initState();
  }

  Future<void> _deleteNotification(
    BuildContext context,
    String notificationId,
  ) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Notification'),
        content: const Text(
          'Are you sure you want to delete this notification?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              callDelFunction(notificationId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  callDelFunction(notifyId) {
    ref
        .read(notifyData)
        .deleteNotification(
          loadingfor: notifyId,
          notificationId: notifyId,
          uid: ref.read(userDataClass).userId,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var userData = ref.watch(userDataClass).userData;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        title: Image.asset(ImgAssets.logoShadow, width: 80),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileDetailsPage()),
              );
            },
            child: CacheImageWidget(
              width: 45,
              height: 45,
              url:
                  ref.watch(userDataClass).userModel?.fullImageUrl ??
                  ImgLinks.profileImage,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
            child: Text(
              "Notifications Users",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          ref.watch(notifyData).loadingFor == "fetchNotifyData"
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 250),
                    child: DotLoader(),
                  ),
                )
              : ref.watch(notifyData).notify.isEmpty
              ? const Center(child: Text("Notifications Empty"))
              : Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: ref.watch(notifyData).notify.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = ref.watch(notifyData).notify[index];

                      return Stack(
                        children: [
                          ListTile(
                            onTap: () {
                              goto(
                                NotificationsDetails(fullData: item.toJson()),
                              );
                            },
                            leading: Stack(
                              children: [
                                CacheImageWidget(
                                  width: 48,
                                  height: 48,
                                  url:
                                      item.fromUser?.fullImageUrl ??
                                      ImgLinks.profileImage,
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
                            title: Text(item.displayTitle),
                            subtitle: Text(
                              item.formattedCreatedDate,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child:
                                ref.watch(notifyData).loadingFor ==
                                    item.id.toString()
                                ? DotLoader(showDots: 1)
                                : GestureDetector(
                                    onTap: () => _deleteNotification(
                                      context,
                                      item.id.toString(),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                          255,
                                          238,
                                          236,
                                          236,
                                        ).withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.delete,
                                        size: 18,
                                        color: Color.fromARGB(255, 193, 16, 4),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

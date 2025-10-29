import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_widgets/widgets/tiktok.dart';
import 'package:rent/constants/appColors.dart';

import 'package:rent/services/goto.dart';
import 'package:rent/constants/screensizes.dart';
import 'package:rent/design/notify/notificationsdetails.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/delete_alert_box.dart';
import 'package:rent/widgets/dotloader.dart';
// import 'package:rent/temp/data.dart';
import '../../constants/api_endpoints.dart';
import '../../constants/images.dart';
import '../../apidata/notifyData.dart';
import '../../apidata/user.dart';
import '../../models/notification_model.dart';
import '../auth/profile_details_page.dart';

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

  @override
  Widget build(BuildContext context) {
    var userData = ref.watch(userDataClass).userData;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        // title: Image.asset(ImgAssets.logoShadow, width: 80),
        title: Text(
          "Notifications Users",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
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
              url: ref.watch(userDataClass).userModel!.image.toString(),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.mainColor,
        backgroundColor: Colors.white,
        onRefresh: () async {
          await ref
              .watch(notifyData)
              .getNotifyData(
                loadingFor: "refresh",
                refresh: true,
                uid: ref.watch(userDataClass).userId,
              );
        },
        child: Column(
          children: [
            ref.watch(notifyData).loadingFor == "refresh"
                ? QuickTikTokLoader(
                    progressColor: AppColors.mainColor,
                    backgroundColor: Colors.black,
                  )
                : SizedBox.shrink(),
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
                                goto(NotificationsDetails(index: index));
                              },
                              leading: Stack(
                                children: [
                                  CacheImageWidget(
                                    width: 48,
                                    height: 48,
                                    url: item.fromUser!.image.toString(),
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
                                  ? DotLoader(showDots: 1, spacing: 0)
                                  : GestureDetector(
                                      onTap: () => alertBoxDelete(
                                        context,
                                        onDeleteTap: () {
                                          ref
                                              .read(notifyData)
                                              .deleteNotification(
                                                loadingfor: item.id.toString(),
                                                notificationId: item.id
                                                    .toString(),
                                                uid: ref
                                                    .read(userDataClass)
                                                    .userId,
                                              );
                                        },
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
                                          color: Color.fromARGB(
                                            255,
                                            193,
                                            16,
                                            4,
                                          ),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quick_widgets/widgets/tiktok.dart';
import 'package:rent/apidata/messegeapi.dart';
import 'package:rent/apidata/user.dart';
import 'package:rent/constants/images.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent/design/auth/profile_details_page.dart';
import 'package:rent/design/message/chat.dart';
import 'package:rent/widgets/btmnavbar.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';

import '../../constants/api_endpoints.dart';
import '../../constants/appColors.dart';
import '../../models/chat_model.dart';
import '../../services/goto.dart';

class ChatedUsersPage extends ConsumerStatefulWidget {
  const ChatedUsersPage({super.key});

  @override
  ConsumerState<ChatedUsersPage> createState() => _ChatedUsersPageState();
}

class _ChatedUsersPageState extends ConsumerState<ChatedUsersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .watch(chatClass)
          .chatedUsers(
            loadingFor: "chatedUsers",
            uid: ref.watch(userDataClass).userData['id'].toString(),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.white, AppColors.mainColor.shade100],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Chats",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
          actions: [
            SizedBox(width: 5),
            Container(
              decoration: BoxDecoration(
                color: Colors.cyan.shade700,
                borderRadius: BorderRadius.circular(25),
              ),
              width: 38,
              height: 38,
              clipBehavior: Clip.antiAlias,
              child: CacheImageWidget(
                onTap: () {
                  goto(ProfileDetailsPage());
                },
                url: ref.watch(userDataClass).userData['image'],
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
        bottomNavigationBar: BottomNavBarWidget(currentIndex: 3),

        body: RefreshIndicator(
          color: AppColors.mainColor,
          backgroundColor: Colors.white,
          onRefresh: () async {
            await ref
                .watch(chatClass)
                .chatedUsers(
                  loadingFor: "refresh",
                  uid: ref.watch(userDataClass).userData['id'].toString(),
                  refresh: true,
                );
          },
          child: Center(
            child: Column(
              children: [
                ref.watch(chatClass).loadingFor == "refresh"
                    ? QuickTikTokLoader(
                        progressColor: Colors.black,
                        backgroundColor: AppColors.mainColor,
                      )
                    : SizedBox.shrink(),
                SizedBox(height: 20),
                ref.watch(chatClass).loadingFor == "chatedUsers"
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 250),
                          child: DotLoader(),
                        ),
                      )
                    :
                      // ✅ ListView.builder yahan lagaya h
                      Expanded(
                        child: ListView.separated(
                          itemCount: ref
                              .watch(chatClass)
                              .chatedUsersList
                              .length,
                          separatorBuilder: (context, index) {
                            final msg = ref
                                .watch(chatClass)
                                .chatedUsersList[index];
                            if (msg.fromuid == null || msg.touid == null) {
                              return SizedBox.shrink();
                            }

                            return Divider(color: Colors.black12);
                          },
                          itemBuilder: (context, index) {
                            final msg = ref
                                .watch(chatClass)
                                .chatedUsersList[index];
                            if (msg.fromuid == null || msg.touid == null) {
                              return SizedBox.shrink();
                            }

                            return ListTile(
                              minVerticalPadding: 1,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              leading: Container(
                                decoration: BoxDecoration(
                                  color: Colors.cyan.shade700,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                width: 41,
                                height: 41,
                                clipBehavior: Clip.antiAlias,
                                child: CacheImageWidget(
                                  url:
                                      (msg.sid.toString() ==
                                          ref
                                              .watch(userDataClass)
                                              .userData['id']
                                              .toString())
                                      ? msg.touid!.image!
                                      : msg.fromuid!.image!,
                                  // msg.fromuid!.image!,
                                ),
                              ),
                              title: Text(
                                (msg.sid.toString() ==
                                        ref
                                            .watch(userDataClass)
                                            .userData['id']
                                            .toString())
                                    ? msg.touid!.name.toString()
                                    : msg.fromuid!.name.toString(),
                                // msg.fromuid!.name.toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(msg.msg.toString()),
                              onTap: () async {
                                await goto(Chats(msgdata: msg));
                              },
                            );
                          },
                        ),
                      ),

                // Text("${ref.watch(chatClass).messege}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rent/apidata/messegeapi.dart';
import 'package:rent/apidata/user.dart';
import 'package:rent/constants/images.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent/message/chat.dart';
import 'package:rent/widgets/btmnavbar.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';

import '../constants/goto.dart';

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
            loadingFor: "abc",
            uid: ref.watch(userDataClass).userdata.id.toString(),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chats",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        actions: [
          const SizedBox(width: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.cyan.shade700,
              borderRadius: BorderRadius.circular(25),
            ),
            width: 38,
            height: 38,
            clipBehavior: Clip.antiAlias,
            child: CacheImageWidget(
              url: Config.imgUrl + ref.watch(userDataClass).userdata.image,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      bottomNavigationBar: BottomNavBarWidget(currentIndex: 3),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ref.watch(chatClass).loadingFor == "abc"
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 250),
                      child: DotLoader(),
                    ),
                  )
                : Expanded(
                    child: ListView.separated(
                      itemCount: ref
                          .watch(chatClass)
                          .usersChatedData!
                          .chatedUsers
                          .length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final chatedUser = ref
                            .watch(chatClass)
                            .usersChatedData!
                            .chatedUsers[index];
                        return ListTile(
                          minVerticalPadding: 1,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          leading: GestureDetector(
                            onTap: () {
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierColor: Colors.black,
                                transitionDuration: const Duration(
                                  milliseconds: 200,
                                ),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                      return Scaffold(
                                        backgroundColor: Colors.black,
                                        appBar: AppBar(
                                          backgroundColor: Colors.black,
                                          elevation: 0,
                                          iconTheme: const IconThemeData(
                                            color: Colors.white,
                                          ),
                                          title: const Text(
                                            "Profile photo",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          actions: const [
                                            Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 20),
                                            Icon(
                                              Icons.share,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 10),
                                          ],
                                        ),
                                        body: Center(
                                          child: InteractiveViewer(
                                            minScale: 1,
                                            maxScale: 4,
                                            child: CacheImageWidget(
                                              url:
                                                  Config.imgUrl +
                                                  chatedUser.fromuid.image,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.cyan.shade700,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              width: 41,
                              height: 41,
                              clipBehavior: Clip.antiAlias,
                              child: CacheImageWidget(
                                url: Config.imgUrl + chatedUser.fromuid.image,
                              ),
                            ),
                          ),
                          title: Text(
                            chatedUser.fromuid.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(chatedUser.msg),
                          onTap: () async {
                            await goto(Chats(msgdata: chatedUser));
                          },
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

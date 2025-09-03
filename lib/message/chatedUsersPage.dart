import 'package:flutter/material.dart';
import 'package:rent/Auth/profile_details_page.dart';
import 'package:rent/apidata/messegeapi.dart';
import 'package:rent/apidata/user.dart';
import 'package:rent/constants/images.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent/message/chatingWithUser.dart';
import 'package:rent/widgets/btmnavbar.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';
import 'package:rent/widgets/lartgeimageview.dart';
import 'package:transparent_route/transparent_route.dart';
import '../constants/goto.dart';
// import 'package:share_plus/share_plus.dart'; // ✅ Make sure this line exists

class ChatedUsersPage extends ConsumerStatefulWidget {
  const ChatedUsersPage({super.key});

  @override
  ConsumerState<ChatedUsersPage> createState() => _ChatedUsersPageState();
}

class _ChatedUsersPageState extends ConsumerState<ChatedUsersPage> {
  bool isStarred = false; // For star toggle

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
          GestureDetector(
            onTap: () {
              goto(const ProfileDetailsPage());

              // LargeImageViewSheet(

              //   // Config.imgUrl + ref.watch(userDataClass).userdata.image,
              // );
            },
            child: CircleAvatar(
              radius: 19,
              backgroundColor: Colors.cyan.shade700,
              backgroundImage: NetworkImage(
                Config.imgUrl + ref.watch(userDataClass).userdata.image,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      bottomNavigationBar: BottomNavBarWidget(currentIndex: 3),
      body: ref.watch(chatClass).loadingFor == "abc"
          ? const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 250),
                child: DotLoader(),
              ),
            )
          : ListView.separated(
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  leading: GestureDetector(
                    onTap: () {
                      LargeImageViewSheet(
                        Config.imgUrl + chatedUser.fromuid.image,
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.cyan.shade700,
                      backgroundImage: NetworkImage(
                        Config.imgUrl + chatedUser.fromuid.image,
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
                    await goto(ChatingWithUserPage(msgdata: chatedUser));
                  },
                );
              },
            ),
    );
  }
}

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
            uid: ref.watch(userDataClass).userdata['id'].toString(),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              url: Config.imgUrl + ref.watch(userDataClass).userdata['image'],
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      bottomNavigationBar: BottomNavBarWidget(currentIndex: 3,),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            ref.watch(chatClass).loadingFor == "abc"
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
                      itemCount: ref.watch(chatClass).chatedUsersList.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        final msg = ref.watch(chatClass).chatedUsersList[index];
                        return ListTile(
                          minVerticalPadding:1,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          leading: Container(
                            decoration: BoxDecoration(
                              color: Colors.cyan.shade700,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            width: 41,
                            height: 41,
                            clipBehavior: Clip.antiAlias,
                            child: CacheImageWidget(
                              url: Config.imgUrl + msg['fromuid']["image"],
                            ),
                          ),
                          title: Text(
                            msg['fromuid']['name'].toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(msg['msg'].toString()),
                          onTap: () async {
                            var result = await goto(Chats(msgdata: msg));

                            if (result != null &&
                                result is String &&
                                result.isNotEmpty) {
                              setState(() {
                                msg['lastMsg'] =
                                    result; // last message update hoga
                              });
                            }
                          },
                        );
                      },
                    ),
                  ),

            // Text("${ref.watch(chatClass).messege}"),
          ],
        ),
      ),
    );
  }
}

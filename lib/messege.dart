import 'package:flutter/material.dart';
import 'package:rent/apidata/messegeapi.dart';
import 'package:rent/apidata/user.dart';
import 'package:rent/constants/data.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rent/message/chat.dart';
import 'package:rent/widgets/casheimage.dart';

import 'constants/goto.dart';

class MessagesHome extends ConsumerStatefulWidget {
  const MessagesHome({super.key});

  @override
  ConsumerState<MessagesHome> createState() => _MessagesHomeState();
}

class _MessagesHomeState extends ConsumerState<MessagesHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .watch(chatClass)
          .chatmsg(
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

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),

            // ✅ ListView.builder yahan lagaya h
            Expanded(
              child: ListView.builder(
                itemCount: ref.watch(chatClass).chatedUsersList.length,
                itemBuilder: (context, index) {
                  final msg = ref.watch(chatClass).chatedUsersList[index];
                  return ListTile(
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
                    onTap: () {
                      goto(Chats(msgdata: msg));
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

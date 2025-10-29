import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/apidata/notifyData.dart';
import 'package:rent/constants/images.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../apidata/user.dart';
import '../../constants/api_endpoints.dart';
import '../../models/chatedUsersModel.dart';
import '../../services/goto.dart';
import '../../services/toast.dart';
import '../../widgets/casheimage.dart';
import '../message/chat.dart';

class NotificationsDetails extends ConsumerStatefulWidget {
  final int index;

  const NotificationsDetails({super.key, required this.index});

  @override
  ConsumerState<NotificationsDetails> createState() =>
      _NotificationsDetailsState();
}

class _NotificationsDetailsState extends ConsumerState<NotificationsDetails> {
  @override
  Widget build(BuildContext context) {
    var notify = ref.watch(notifyData).notify[widget.index];
    return Scaffold(
      appBar: AppBar(title: const Text("Notification Details")),
      floatingActionButton:
          (notify.fromUser == null ||
              notify.fromUser?.id.toString() ==
                  ref.watch(userDataClass).userData['id'].toString())
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                if (notify.fromUser == null) {
                  toast("User not Available From Long Time!");
                  return;
                }
                goto(
                  Chats(
                    msgdata: ChatedUsersModel(
                      id: 1,
                      sid: int.tryParse(
                        ref.watch(userDataClass).userData["id"].toString(),
                      ),
                      rid: int.tryParse(notify.fromUser!.id.toString()),
                      msg: "",
                      fromuid: ChatUser(
                        id: int.tryParse(
                          ref.watch(userDataClass).userData["id"].toString(),
                        ),
                        image: ref
                            .watch(userDataClass)
                            .userData["image"]
                            .toString(),
                        name: ref
                            .watch(userDataClass)
                            .userData["name"]
                            .toString(),
                      ),
                      touid: ChatUser(
                        id: int.tryParse(notify.fromUser!.id.toString()),
                        image: notify.fromUser!.image.toString(),
                        name: notify.fromUser!.name.toString(),
                      ),
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.chat_outlined,
                size: 22,
                color: Colors.white,
              ),
            ).animate().scale(
              delay: Duration(milliseconds: 300),
              duration: Duration(milliseconds: 500),
            ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notify.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),
            // Text(
            //   "${notify['desc'] ?? 'Description.......'}",
            //   style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            // ),
            HtmlWidget(notify.description),

            Divider(),
            ListTile(title: Text("From User")),
            ListTile(
              leading: CacheImageWidget(
                width: 50,
                height: 50,
                isCircle: true,
                radius: 200,
                url: notify.fromUser!.image!,
              ),
              title: Text(notify.fromUser!.name),
              subtitle: Text(notify.fromUser!.email),
            ),
          ],
        ),
      ),
    );
  }
}

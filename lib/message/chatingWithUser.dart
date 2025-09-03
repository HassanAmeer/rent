import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/apidata/messegeapi.dart';
import 'package:rent/apidata/user.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/models/chatedmodel.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';
import 'package:rent/widgets/lartgeimageview.dart';

// ignore: must_be_immutable
class ChatingWithUserPage extends ConsumerStatefulWidget {
  ChatedUser msgdata;
  ChatingWithUserPage({super.key, required this.msgdata});

  @override
  ConsumerState<ChatingWithUserPage> createState() =>
      _ChatingWithUserPageState();
}

class _ChatingWithUserPageState extends ConsumerState<ChatingWithUserPage> {
  final TextEditingController _controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var senderId = ref.watch(userDataClass).userdata.id.toString();

      var recieverId =
          ref.watch(userDataClass).userdata.id.toString() == widget.msgdata.sid
          ? widget.msgdata.rid
          : widget.msgdata.sid;

      await ref
          .watch(chatClass)
          .getUserMsgs(
            loadingfor: "getallchats",
            senderId: senderId.toString(),
            recieverId: recieverId.toString(),
            scrollController: scrollController,
          )
          .then((v) {});
    });
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isNotEmpty) {
      String message = _controller.text.trim();

      var senderId = ref.watch(userDataClass).userdata.id.toString();
      var recieverId =
          ref.watch(userDataClass).userdata.id.toString() == widget.msgdata.sid
          ? widget.msgdata.rid
          : widget.msgdata.sid;

      await ref
          .watch(chatClass)
          .sndingmsgs(
            senderId: senderId.toString(),
            recieverId: recieverId.toString(),
            msg: message,
            time: DateTime.now().toString(),
            loadingfor: "sendmsg",
            scrollController: scrollController,
          );

      _controller.clear();
    } else {
      toast("Write Something");
    }
  }

  @override
  Widget build(BuildContext context) {
    var chatProvider = ref.watch(chatClass);
    var userProvider = ref.watch(userDataClass);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref
                .read(chatClass)
                .chatedUsers(
                  uid: ref.read(userDataClass).userdata.id.toString(),
                );

            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                LargeImageViewSheet(
                  Config.imgUrl + widget.msgdata.fromuid.image,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan.shade700,
                  borderRadius: BorderRadius.circular(25),
                ),
                width: 35,
                height: 35,
                clipBehavior: Clip.antiAlias,
                child: CacheImageWidget(
                  url:
                      Config.imgUrl +
                      (widget.msgdata.fromuid.id.toString() ==
                              ref.watch(userDataClass).userdata.id.toString()
                          ? widget.msgdata.touid.image
                          : widget.msgdata.fromuid.image),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.msgdata.fromuid.id.toString() ==
                          ref.watch(userDataClass).userdata.id.toString()
                      ? widget.msgdata.touid.name
                      : widget.msgdata.fromuid.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: chatProvider.loadingFor == "getallchats"
          ? const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 2),
                child: DotLoader(),
              ),
            )
          : chatProvider.usersChatingData == null ||
                chatProvider.usersChatingData!.chats.isEmpty
          ? const Center(child: Text("No messages yet"))
          : ListView.builder(
              itemCount: chatProvider.usersChatingData!.chats.length,
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                bottom: 88,
                top: 10,
              ),
              controller: scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var chat = chatProvider.usersChatingData!.chats[index];
                bool isMe = userProvider.userdata.id == chat.sid;

                return Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 250),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.black : Colors.cyan,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isMe ? 16 : 0),
                            bottomRight: Radius.circular(isMe ? 0 : 16),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8.0,
                          ),
                          child: Text(
                            chat.msg,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Type a message",
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.send,
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.cyan.shade700,
              child: IconButton(
                icon: ref.watch(chatClass).loadingFor == "sendmsg"
                    ? CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation(Colors.grey),
                        strokeWidth: 2,
                      )
                    : const Icon(Icons.send, color: Colors.white),
                onPressed: () async {
                  await _sendMessage();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

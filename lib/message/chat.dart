import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/apidata/messegeapi.dart';
import 'package:rent/apidata/user.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/models/chatedmodel.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';

// ignore: must_be_immutable
class Chats extends ConsumerStatefulWidget {
  ChatedUser msgdata = ChatedUser(fromuid: User(), touid: User());
  Chats({super.key, required this.msgdata});

  @override
  ConsumerState<Chats> createState() => _ChatsState();
}

//////////
class _ChatsState extends ConsumerState<Chats> {
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

      print("senderId: $senderId");
      print("recieverId: $recieverId");

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

      // ✅ Clear input field
      _controller.clear();
    } else {
      toast("Write Something");
    }
  }

  /// ✅ Fullscreen Image Viewer with swipe-to-close
  void _openFullImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            GestureDetector(
              onVerticalDragEnd: (_) => Navigator.of(context).pop(),
              child: InteractiveViewer(
                child: Center(
                  child: CacheImageWidget(url: imageUrl, fit: BoxFit.contain),
                ),
              ),
            ),
            Positioned(
              top: 30,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
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
                _openFullImage(Config.imgUrl + widget.msgdata.fromuid.image);
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
                  url: Config.imgUrl + widget.msgdata.fromuid.image,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.msgdata.fromuid.name,
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
          : ListView.builder(
              itemCount: chatProvider.usersChatedData!.chatedUsers.length,
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
      floatingActionButton: // ✅ Chat Input Box
      Container(
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

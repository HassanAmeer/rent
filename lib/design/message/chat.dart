import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/apidata/messegeapi.dart';
import 'package:rent/apidata/user.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/widgets/casheimage.dart';
import 'package:rent/widgets/dotloader.dart';
import 'package:rent/widgets/imageview.dart';

import '../../constants/api_endpoints.dart';
import '../../constants/appColors.dart';
import '../../models/chatedUsersModel.dart';
import '../../services/toast.dart';

class Chats extends ConsumerStatefulWidget {
  final ChatedUsersModel msgdata;
  const Chats({super.key, required this.msgdata});

  @override
  ConsumerState<Chats> createState() => _ChatsState();
}

class _ChatsState extends ConsumerState<Chats> {
  final TextEditingController _controller = TextEditingController();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.msgdata.rid == widget.msgdata.sid) {
        toast("Can Not Chat With Your Self");
        Navigator.pop(context);
        return;
      }
      var senderId = ref.watch(userDataClass).userData['id'].toString();

      var recieverId =
          ref.watch(userDataClass).userData['id'].toString() ==
              widget.msgdata.sid.toString()
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

      var senderId = ref.watch(userDataClass).userData['id'].toString();

      var recieverId =
          ref.watch(userDataClass).userData['id'].toString() ==
              widget.msgdata.sid.toString()
          ? widget.msgdata.rid
          : widget.msgdata.sid;

      debugPrint("senderId: $senderId");
      debugPrint("recieverId: $recieverId");
      // return;
      await ref
          .watch(chatClass)
          .sendingOrCreatingmsg(
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

  @override
  Widget build(BuildContext context) {
    var chatProvider = ref.watch(chatClass);
    var userProvider = ref.watch(userDataClass);

    // ✅ Last message preview

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
          elevation: 0,
          // iconTheme: const IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              ref
                  .read(chatClass)
                  .chatedUsers(
                    loadingFor: 'refresh',
                    refresh: true,
                    uid: ref.read(userDataClass).userData['id'].toString(),
                  );
              Navigator.pop(context);
            },
          ),

          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.cyan.shade700,
                  borderRadius: BorderRadius.circular(25),
                ),
                width: 35,
                height: 35,
                clipBehavior: Clip.antiAlias,
                child: CacheImageWidget(
                  onTap: () {
                    showImageView(context, widget.msgdata.touid!.image!);
                  },
                  url: widget.msgdata.touid!.image!,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text("${widget.msgdata.sid}"),
                  Text(
                    widget.msgdata.touid!.name ?? "User Name",
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

        body:
            // Text("Chat with ${widget.msgdata}"),
            // SizedBox(
            //   height: 777,
            //   child: SingleChildScrollView(
            //     child: Text("${chatProvider.messagesList}"),
            //   ),
            // ),
            // ✅ Chats List
            chatProvider.loadingFor == "getallchats"
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: DotLoader(),
                ),
              )
            : ListView.builder(
                itemCount: chatProvider.messagesData!.chats!.length,
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  bottom: 88,
                  top: 10,
                ),
                controller: scrollController,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var chat = chatProvider.messagesData!.chats![index];
                  bool isMe =
                      userProvider.userData['id'].toString() ==
                      chat.sid!.toString();

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
                              chat.msg!,
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
        Padding(
          padding: const EdgeInsets.only(
            left: 14,
            right: 14,
            top: 8.0,
            bottom: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                    // border: Border.all(color: Colors.transparent, width: 0),
                  ),
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
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
      ),
    );
  }
}

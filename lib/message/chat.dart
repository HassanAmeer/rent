import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/apidata/messegeapi.dart';
import 'package:rent/apidata/user.dart';
import 'package:rent/constants/data.dart';
import 'package:rent/widgets/casheimage.dart';

class Chats extends ConsumerStatefulWidget {
  var msgdata;
  Chats({super.key, required this.msgdata});

  @override
  ConsumerState<Chats> createState() => _ChatsState();
}

class _ChatsState extends ConsumerState<Chats> {
  final TextEditingController _controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // If using Riverpod, obtain ref from context
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .watch(chatClass)
          .sndmsgs(
            loadingfor: "getallchats",
            recieverId: widget.msgdata['rid'].toString(),
            senderId: widget.msgdata['sid'].toString(),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.cyan.shade700,
              borderRadius: BorderRadius.circular(25),
            ),
            width: 12,
            height: 12,
            clipBehavior: Clip.antiAlias,
            child: CacheImageWidget(
              url: Config.imgUrl + widget.msgdata['fromuid']["image"],
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.msgdata['fromuid']["name"] ?? "User Name",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              "User ID: 12345",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          ListView.builder(
            itemCount: ref.watch(chatClass).messagesList.length,
            shrinkWrap: true,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              var chat = ref.watch(chatClass).messagesList[index];
              return Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  crossAxisAlignment:
                      ref.watch(userDataClass).userdata['id'] == chat['sid']
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisAlignment:
                      ref.watch(userDataClass).userdata['id'] == chat['sid']
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color:
                            ref.watch(userDataClass).userdata['id'] ==
                                chat['sid']
                            ? Colors.black
                            : Colors.cyan,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8.0,
                        ),
                        child: Text(
                          chat['msg'],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          // Your chat messages go here

          // Text("${ref.watch(chatClass).messagesList}"),

          // Chat Input Box
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          border: InputBorder.none,
                        ),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            print("Send: $value");
                            _controller.clear();
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.cyan.shade700,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        if (_controller.text.trim().isNotEmpty) {
                          print("Send: ${_controller.text}");
                          _controller.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

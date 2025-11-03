import 'dart:ui';

import 'package:chatapp/provider/messageProvider.dart';
import 'package:chatapp/provider/online_status_provider.dart';
import 'package:chatapp/provider/socket_provider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String fullname;
  final String receiverId;
  const ChatScreen({
    super.key,
    required this.fullname,
    required this.receiverId,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isAtBottom = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final userId = ref.read(userProvider)!.id;
    ref.read(messageProvider(widget.receiverId).notifier).chatOpened(userId);
    scrollController.addListener((){
      var isAtBottomNow = scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50;
      if(isAtBottomNow != isAtBottom){
        setState(() {
          isAtBottom = isAtBottomNow;
        });
      }
    });

  }


  void scrollToBottom(){
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    print('Disposed');
  }

  /*   void closeChat(){
    final userId = ref.read(userProvider)!.id;
    ref.read(messageProvider(widget.receiverId).notifier).chatClosed(userId);
  } */

  // void markAllMessageAsSeen(){
  //   final message = ref.read(messageProvider(widget.receiverId));
  //   final userId = ref.read(userProvider)!.id;
  //   for (final msg in message){
  //     if(msg.status != 'seen' && msg.senderId != userId){
  //       ref.read(socketProvider).markAsSeen(msg.id);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messageProvider(widget.receiverId));
    final status = ref.watch(statusListener);
    final receiverStatus = status[widget.receiverId];
    final isOnline = receiverStatus?.isOnline ?? false;
    final lastSeen = receiverStatus?.lastSeen;
    final user = ref.watch(userProvider);
    return PopScope(
      canPop: true, // allow pop after our logic
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          final userId = ref.read(userProvider)!.id;
          ref
              .read(messageProvider(widget.receiverId).notifier)
              .chatClosed(userId);
          print('🔙 System back pressed → chatClosed emitted');
          Navigator.pop(context); // only manually pop if Flutter didn't
        } else {
          final userId = ref.read(userProvider)!.id;
          ref
              .read(messageProvider(widget.receiverId).notifier)
              .chatClosed(userId);
          print('🔙 System back pressed → chatClosed emitted (auto pop)');
        }
      },

      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              /*         final userId = ref.read(userProvider)!.id;
              ref
                  .read(messageProvider(widget.receiverId).notifier)
                  .chatClosed(userId); */
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.fullname,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color:
                        status[widget.receiverId]?.isOnline == true
                            ? Colors.green
                            : Colors.red,
                    size: 10,
                  ),
                  Text(
                    isOnline
                        ? "Online"
                        : lastSeen != null
                        ? "Last Seen:${lastSeen.toLocal()}"
                        : "Offline",
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          elevation: 0,
        ),

        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isMe = message.senderId == user!.id;
                  return Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.deepPurpleAccent : Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            message.message,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ).animate().fade().scale(),
                          if (isMe) ...[
                            SizedBox(height: 3),
                            _buildStatusIcon(message.status),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

              if(!isAtBottom)
                Positioned(
                    child: IconButton(onPressed:(){
                      scrollToBottom();
                    }, icon: Icon(Icons.arrow_circle_down_sharp))
                ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 10.0,
              ),
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.all(10),
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.emoji_emotions_outlined),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      await ref
                          .read(messageProvider(widget.receiverId).notifier)
                          .sendMessage(userMessage: messageController.text);
                      scrollController.jumpTo(scrollController.position.maxScrollExtent);
                      messageController.clear();
                    },
                    icon: Icon(Icons.send),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    switch (status) {
      case 'seen':
        return Icon(Icons.done_all, color: Colors.blueAccent);
      case 'delivered':
        return Icon(Icons.done_all, color: Colors.grey);
      case 'sent':
        return Icon(Icons.done, color: Colors.grey);
      default:
        return const SizedBox.shrink();
    }
  }
}

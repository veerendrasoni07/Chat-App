import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/provider/group_message_provider.dart';
import 'package:chatapp/provider/messageProvider.dart';
import 'package:chatapp/provider/socket_provider.dart';

import 'package:chatapp/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';





class GroupChatScreen extends ConsumerStatefulWidget {
  final User user;
  final String fullname;
  final String groupId;
  const GroupChatScreen({
    super.key,
    required this.fullname,
    required this.groupId,
    required this.user,
  });

  @override
  ConsumerState<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends ConsumerState<GroupChatScreen> {
  final TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isAtBottom = true;


  void groupChatOpened(){
    final socket = ref.read(socketProvider);
    socket.groupMessageOpened(widget.user.id, widget.groupId);
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupChatOpened();
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
    messageController.dispose();
    print('Disposed');
  }

  @override
  Widget build(BuildContext context) {
    final groupMessage = ref.watch(groupMessageProvider(widget.groupId));
    final user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height*0.08),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
            child: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.inversePrimary),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    widget.fullname,
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),

                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
              elevation: 0,
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: groupMessage.length,
              itemBuilder: (context, index) {
                final message = groupMessage[index];
                final isMe = message.senderId == user!.id;
                return Align(
                  alignment:
                  isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(
                      vertical: 5.h,
                      horizontal: 10.w,
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
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ).animate().fade().scale(),

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
            padding:  EdgeInsets.symmetric(
              vertical: 15.h,
              horizontal: 10.0.w,
            ),
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),
                contentPadding: EdgeInsets.all(10.sp),
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                prefixIcon: Icon(Icons.door_back_door_outlined,color: Theme.of(context).colorScheme.inversePrimary,),
                suffixIcon: IconButton(
                  onPressed: () async {
                    print(widget.groupId);
                    await ref
                        .read(groupMessageProvider(widget.groupId).notifier)
                        .sendGroupMessage(senderId: user!.id,message: messageController.text);
                    messageController.clear();
                  },
                  icon: Icon(Icons.send,color: Theme.of(context).colorScheme.inversePrimary,),
                ),
              ),
            ),
          ),
        ],
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

import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatapp/localDB/model/user_isar.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/provider/group_message_provider.dart';
import 'package:chatapp/provider/messageProvider.dart';
import 'package:chatapp/provider/socket_provider.dart';

import 'package:chatapp/provider/userProvider.dart';
import 'package:chatapp/views/screens/details/group_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';





class GroupChatScreen extends ConsumerStatefulWidget {
  final User user;
  final List<UserIsar> groupMembers;
  final String groupPic;
  final List<UserIsar> groupAdmin;
  final String fullname;
  final String groupId;
  const GroupChatScreen({
    super.key,
    required this.groupMembers,
    required this.groupAdmin,
    required this.fullname,
    required this.groupId,
    required this.groupPic,
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
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
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
                icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.primary),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>GroupScreen(groupMembers: widget.groupMembers.toList(),groupName: widget.fullname,proPic: widget.groupPic,groupAdmin: widget.groupAdmin.toList(),))),
                    child: AutoSizeText(
                      widget.fullname,
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Text("${widget.groupAdmin.map((u){
                    if(u.fullname == user!.fullname){
                      return "You";
                    }else{
                      return u.fullname;
                    }
                  }).join(',')},${widget.groupMembers.map((u) {
                    if(u.fullname == user!.fullname){
                      return "You";
                    }else{
                      return u.fullname;
                    }
                  }).join(',')}",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    overflow: TextOverflow.ellipsis,
                  )

                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              elevation: 0,
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,

      body: Container(
        decoration : const BoxDecoration(
            gradient: LinearGradient(colors: [
               Color(0xFF450072),
               Color(0xFF270249),
               Color(0xFF1F0033)
            ])
        ),
        child:  Column(
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
                      padding: const EdgeInsets.all(10),
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
                              color: Theme.of(context).colorScheme.primary,
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
                  }, icon: const Icon(Icons.arrow_circle_down_sharp))
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
                  fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  contentPadding: EdgeInsets.all(10.sp),
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                  prefixIcon: Icon(Icons.door_back_door_outlined,color: Theme.of(context).colorScheme.primary,),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      await ref
                          .read(groupMessageProvider(widget.groupId).notifier)
                          .sendGroupMessage(senderId: user!.id,message: messageController.text);
                      messageController.clear();
                    },
                    icon: Icon(Icons.send,color: Theme.of(context).colorScheme.primary,),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
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

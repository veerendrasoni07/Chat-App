
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orbit_chat_app/componentss/alert_dialog_warning.dart';
import 'package:orbit_chat_app/localDB/model/user_isar.dart';
import 'package:orbit_chat_app/localDB/provider/isar_provider.dart';
import 'package:orbit_chat_app/localDB/service/isar_service.dart';
import 'package:orbit_chat_app/provider/combined_chat_provider.dart';
import 'package:orbit_chat_app/provider/friend_controller_provider.dart';
import 'package:orbit_chat_app/provider/userProvider.dart';
import 'package:orbit_chat_app/views/screens/details/chat_screen.dart';

class ChatTile extends ConsumerWidget {
  final String chatId;
  final bool isGroup;

  const ChatTile({required this.chatId, required this.isGroup, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendRepo = ref.read(friendRepoProvider);
    // friend/group info (cheap)
    final name =
        // ? ref.watch(groupInfoProvider(chatId)).value?.groupName ?? 'Group'
         ref.watch(friendInfoProvider(chatId)).value?.fullname ?? 'User' ;
    // final picture = isGroup ? ref.watch(groupInfoProvider(chatId)).value?.groupPic ?? 'Group'
    //     : ref.watch(friendInfoProvider(chatId)).value?.profilePic ?? 'User';
    // final Iterable<UserIsar>? groupMembers = isGroup ? ref.watch(groupInfoProvider(chatId)).value?.groupMembers : [] ;
    // final Iterable<UserIsar>? groupAdmins = isGroup ? ref.watch(groupInfoProvider(chatId)).value?.groupAdmins : [];
    final isar = ref.read(isarProvider);
    // tiny derived data — will rebuild only if these particular values change
    //     final lastMessageTime = isGroup
    //     ? ref.watch(lastGroupMessageProvider(chatId))
    //     : ref.watch(lastMessageProvider(chatId));
    // final unreadCount = isGroup
    // ? ref.watch(unreadGroupMessageCountProvider(chatId))
    //     : ref.watch(unreadChatCountProvider(chatId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Slidable(
        endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                  onPressed: (_)async{
                    showDialog(context: context, builder: (_){
                      return alertDialogWarning(title: Text("Remove Friend"), content: Text("Do you really want to remove $name from your friend list?"), onSave: ()async{
                        isGroup ? (){} : await friendRepo.removeFriend(friendId: chatId,context: context,ref: ref);
                        Navigator.pop(context);
                      }, context: context);
                    });

                  },
                icon: Icons.delete,
                foregroundColor: Colors.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),bottomRight:  Radius.circular(30)),
                label: isGroup ? "Exist" : 'Delete',

                backgroundColor: Colors.white.withOpacity(0.10),
              ),
              if(!isGroup)
                SlidableAction(
                  onPressed: (_){
                    showDialog(context: context, builder: (_){
                      return alertDialogWarning(title: Text("Block User"), content: Text("Do you really want to block $name"), onSave: (){
                        Navigator.pop(context);
                      }, context: context);
                    });
                  },
                  icon: Icons.block_flipped,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withOpacity(0.10),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),bottomRight:  Radius.circular(30)),
                  label: 'Block',

                ),
              SlidableAction(
                onPressed: (_)async{
                  showDialog(context: context, builder: (_){
                    return alertDialogWarning(title: Text("Clear All Messages?"), content: Text("Do you really want to clear all messages (Note:Messages will only clear from your device not from server"), onSave: ()async{
                      await IsarService(isar).clearAllMessage(chatId: chatId, senderId: ref.read(userProvider)!.id);
                      Navigator.pop(context);
                    }, context: context);
                  });
                },
                icon: Icons.more_vert,
                foregroundColor: Colors.white,
                backgroundColor: Colors.white.withOpacity(0.10),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),bottomRight:  Radius.circular(30)),
                label: 'Chat',

              ),
            ]
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.2))
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              children: [
                Positioned.fill(
                    child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 40,
                          sigmaY: 40,
                        )
                    )
                ),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.10),
                        Colors.white.withOpacity(0.04)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                      child: Text(name.isEmpty ? "?" : name[0]),
                    ),
                    title: Text(name, style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary)),
                   // subtitle: unreadCount > 0 ? Text("$unreadCount new messages", style: TextStyle(color: Colors.blueAccent)) : null,
                    onTap: () {
                      if (isGroup) {
                        // Get.to(
                        //         ()=>GroupChatScreen(fullname: name, groupId: chatId, user: ref.read(userProvider)!,groupMembers: groupMembers!.toList(),groupAdmin: groupAdmins!.toList()),
                        //   transition: Transition.cupertino,
                        //   duration: const Duration(milliseconds: 300),
                        //   curve: Curves.easeOutCubic,
                        // );
                      } else {
                        Get.to(
                            ()=>  ChatScreen(
                                receiverId: chatId,
                                fullname: name
                            ),
                          transition: Transition.rightToLeft,
                          duration:const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                        );
                      }
                    },
                  //  trailing: lastMessageTime != null ? Text(_formatTime(lastMessageTime),style: GoogleFonts.poppins(color: Theme.of(context).colorScheme.primary),) : null,
                  ),
                ),
              ],
            ),
          )
        ),
      )
    );
  }

  String _formatTime(DateTime time) {
    // quick human-readable time, customize as you like
    final now = DateTime.now();
    if (now.difference(time).inDays == 0) {
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    }
    return "${time.day}/${time.month}";
  }
}

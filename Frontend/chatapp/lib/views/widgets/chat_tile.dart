
import 'dart:ui';

import 'package:chatapp/models/user.dart';
import 'package:chatapp/provider/combined_chat_provider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp/views/screens/details/chat_screen.dart';
import 'package:chatapp/views/screens/details/group_chat_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatTile extends ConsumerWidget {
  final String chatId;
  final bool isGroup;

  const ChatTile({required this.chatId, required this.isGroup, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // friend/group info (cheap)
    final name = isGroup
        ? ref.watch(groupInfoProvider(chatId))?.groupName ?? 'Group'
        : ref.watch(friendInfoProvider(chatId))?.fullname ?? 'User';
    final picture = isGroup ? ref.watch(groupInfoProvider(chatId))?.groupPic ?? 'Group'
        : ref.watch(friendInfoProvider(chatId))?.fullname ?? 'User';
    final List<User> groupMembers = isGroup ? ref.watch(groupInfoProvider(chatId))!.groupMembers : [];
    final List<User> groupAdmins = isGroup ? ref.watch(groupInfoProvider(chatId))!.groupAdmin : [];
    // tiny derived data — will rebuild only if these particular values change
        final lastMessageTime = isGroup
        ? ref.watch(lastGroupMessageProvider(chatId))
        : ref.watch(lastMessageProvider(chatId));
    final unreadCount = isGroup
    ? ref.watch(unreadGroupMessageCountProvider(chatId))
        : ref.watch(unreadChatCountProvider(chatId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    child: Text(name[0]),
                  ),
                  title: Text(name, style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary)),
                  subtitle: unreadCount > 0 ? Text("$unreadCount new messages", style: TextStyle(color: Colors.blueAccent)) : null,
                  onTap: () {
                    if (isGroup) {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (_) => GroupChatScreen(fullname: name, groupId: chatId, user: ref.read(userProvider)!,groupMembers: groupMembers,groupAdmin: groupAdmins,groupPic: picture,)
                      ));
                    } else {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (_) => ChatScreen(receiverId: chatId, fullname: name)
                      ));
                    }
                  },
                  trailing: lastMessageTime != null ? Text(_formatTime(lastMessageTime),style: GoogleFonts.poppins(color: Theme.of(context).colorScheme.primary),) : null,
                ),
              ),
            ],
          ),
        )
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

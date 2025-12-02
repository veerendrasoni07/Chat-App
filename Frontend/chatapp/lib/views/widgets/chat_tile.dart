
import 'package:chatapp/provider/combined_chat_provider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp/views/screens/details/chat_screen.dart';
import 'package:chatapp/views/screens/details/group_chat_screen.dart';

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

    // tiny derived data — will rebuild only if these particular values change
        final lastMessageTime = isGroup
        ? ref.watch(lastGroupMessageProvider(chatId))
        : ref.watch(lastMessageProvider(chatId));

    final unreadCount = isGroup
    ? ref.watch(unreadGroupMessageCountProvider(chatId))
        : ref.watch(unreadChatCountProvider(chatId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.04),
            borderRadius: BorderRadius.circular(18),
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.15),
              child: Text(name[0]),
            ),
            title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: unreadCount > 0 ? Text("$unreadCount new messages", style: TextStyle(color: Colors.blueAccent)) : null,
            onTap: () {
              if (isGroup) {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) => GroupChatScreen(fullname: name, groupId: chatId, user: ref.read(userProvider)!)
                ));
              } else {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) => ChatScreen(receiverId: chatId, fullname: name)
                ));
              }
            },
            trailing: lastMessageTime != null ? Text(_formatTime(lastMessageTime)) : null,
          ),
        ),
      ),
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

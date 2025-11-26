import 'package:chatapp/models/combined_chat.dart';
import 'package:chatapp/provider/friends_provider.dart';
import 'package:chatapp/provider/group_message_provider.dart';
import 'package:chatapp/provider/group_provider.dart';
import 'package:chatapp/provider/messageProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final combinedChatProvider = Provider((ref){
  final friendChats = ref.watch(friendsProvider);
  final groups = ref.watch(groupProvider);

  final chats = friendChats.map((f){
    final messages = ref.watch(messageProvider(f.id));
    final lastMessage = messages.isNotEmpty ? messages.last.createdAt : DateTime.fromMillisecondsSinceEpoch(0);

    final unread = messages.where((m)=>m.senderId == f.id && m.status != 'seen').length;

    return ChatTileData(
        id: f.id, name: f.fullname, isGroup: false, lastMessageTime: lastMessage!, unreadCount: unread
    );
  }).toList();

  final groupChats = groups.map((g){
    final groupMessages = ref.watch(groupMessageProvider(g.id));
    final lastGroupMessage = groupMessages.isNotEmpty ? groupMessages.last.createdAt : DateTime.fromMillisecondsSinceEpoch(0);

    return ChatTileData(id: g.id, name: g.groupName, isGroup: true, lastMessageTime: lastGroupMessage, unreadCount: 0);


  }).toList();

  final combined = [...chats,...groupChats];
  return combined;

});
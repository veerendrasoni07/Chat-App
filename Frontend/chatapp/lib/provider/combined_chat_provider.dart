import 'package:chatapp/models/chatmeta.dart';
import 'package:chatapp/models/combined_chat.dart';
import 'package:chatapp/models/group.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/provider/friends_provider.dart';
import 'package:chatapp/provider/group_message_provider.dart';
import 'package:chatapp/provider/group_provider.dart';
import 'package:chatapp/provider/messageProvider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final chatListProvider = Provider<List<ChatMeta>>((ref){
  final friends = ref.watch(friendsProvider);
  final groups = ref.watch(groupProvider);

  return [
    ...friends.map((f)=> ChatMeta(id: f.id, isGroup: false)),
    ...groups.map((g)=> ChatMeta(id: g.id, isGroup: true))
  ];

});

final friendInfoProvider = Provider.family<User?, String>((ref, friendId) {
  final friends = ref.watch(friendsProvider);
  try {
    return friends.firstWhere((f) => f.id == friendId);
  } catch (e) {
    return null;
  }
});

final groupInfoProvider = Provider.family<Group?, String>((ref, groupId) {
  final groups = ref.watch(groupProvider);
  try {
    return groups.firstWhere((g) => g.id == groupId);
  } catch (e) {
    return null;
  }
});

/// These watch the message lists but select only the last createdAt (or null).
final lastMessageProvider = Provider.family<DateTime?, String>((ref, chatId) {
  // Works for one-to-one messages
  return ref.watch(
    messageProvider(chatId).select((msgs) =>
    msgs.isNotEmpty ? msgs.last.createdAt : null
    ),
  );
});

final lastGroupMessageProvider = Provider.family<DateTime?,String>((ref,groupId){
  return ref.watch(groupMessageProvider(groupId).select((g){
    return g.isNotEmpty ? g.last.createdAt : null;
  }));
});


// unread count provider
final unreadChatCountProvider = Provider.family<int,String>((ref,friendId){
 return ref.watch(messageProvider(friendId).select((msg){
   return msg.where((m)=> m.senderId == friendId && m.status !='seen').length;
 }));
});

final unreadGroupMessageCountProvider = Provider.family<int,String>((ref,groupId){
  final user = ref.watch(userProvider);
  return ref.watch(groupMessageProvider(groupId).select((msg){
    return msg.where((g)=> !g.seenBy.any((u)=> u.id == user!.id )).length;
  }));
});




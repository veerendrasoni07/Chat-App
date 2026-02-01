
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:orbit_chat_app/localDB/model/group_isar.dart';
import 'package:orbit_chat_app/localDB/model/user_isar.dart';
import 'package:orbit_chat_app/localDB/provider/isar_provider.dart';
import 'package:orbit_chat_app/models/chatmeta.dart';
import 'package:orbit_chat_app/provider/friend_stream_provider.dart';

final combinedChatStream = Provider<AsyncValue<List<ChatMeta>>>((ref){
  final friendStream = ref.watch(friendStreamProvider);
  // final groupStream = ref.watch(groupStreamProvider);

  if(friendStream.isLoading){
    return const AsyncLoading();
  }
  final chats = [
    ...friendStream.value!.map((f)=>ChatMeta(id: f.userId, isGroup: false)),
    // ...groupStream.value!.map((g)=>ChatMeta(id: g.groupId, isGroup: true))
  ];
  return AsyncData(chats);
});

//
// final groupInfoProvider = FutureProvider.family<GroupIsar?,String>((ref,chatId){
//   final isar = ref.read(isarProvider);
//   return isar.groupIsars.filter().groupIdEqualTo(chatId).findFirst();
// });


final friendInfoProvider = FutureProvider.family<UserIsar?,String>((ref,chatId){
  final isar = ref.read(isarProvider);
  return isar.userIsars.filter().userIdEqualTo(chatId).findFirst();
});


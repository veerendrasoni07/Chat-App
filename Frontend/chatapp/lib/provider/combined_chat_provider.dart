
import 'package:demo_isar_app/isar/model/group_isar.dart';
import 'package:demo_isar_app/isar/model/user_isar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:demo_isar_app/model/chatmeta.dart';
import 'package:demo_isar_app/provider/friend_stream_provider.dart';
import 'package:demo_isar_app/provider/group_stream_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final combinedChatStream = Provider<AsyncValue<List<ChatMeta>>>((ref){
  final friendStream = ref.watch(friendStreamProvider);
  final groupStream = ref.watch(groupStreamProvider);

  if(friendStream.isLoading || groupStream.isLoading){
    return const AsyncLoading();
  }
  final chats = [
    ...friendStream.value!.map((f)=>ChatMeta(id: f.userId, isGroup: false)),
    ...groupStream.value!.map((g)=>ChatMeta(id: g.groupId, isGroup: true))
  ];
  return AsyncData(chats);


});

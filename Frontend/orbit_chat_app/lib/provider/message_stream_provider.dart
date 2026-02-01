
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:orbit_chat_app/localDB/model/message_isar.dart';
import 'package:orbit_chat_app/localDB/provider/isar_provider.dart';
import 'package:orbit_chat_app/provider/userProvider.dart';

final messageStreamProvider =
StreamProvider.family<List<MessageIsar>, String>((ref, otherUserId) {
  final isar = ref.read(isarProvider);
  final myId = ref.read(userProvider)!.id;

  return isar.messageIsars
      .filter()
      .group((q) => q
      .senderIdEqualTo(myId)
      .and()
      .chatIdEqualTo(otherUserId))
      .or()
      .group((q) => q
      .senderIdEqualTo(otherUserId)
      .and()
      .chatIdEqualTo(myId))
      .sortByLocalCreatedAt()
      .watch(fireImmediately: true);
});

import 'package:chatapp/localDB/model/message_isar.dart';
import 'package:chatapp/localDB/provider/isar_provider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

final messageStreamProvider =
StreamProvider.family<List<MessageIsar>, String>((ref, otherUserId) {
  final isar = ref.read(isarProvider);
  final myId = ref.read(userProvider)!.id;

  return isar.messageIsars
      .filter()
      .group((q) => q
      .senderIdEqualTo(myId)
      .and()
      .chatIdEqualTo(otherUserId)
      .or()
      .senderIdEqualTo(otherUserId)
      .and()
      .chatIdEqualTo(myId))
      .sortByLocalCreatedAt()
      .watch(fireImmediately: true);
});

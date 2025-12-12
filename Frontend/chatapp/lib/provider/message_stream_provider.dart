

import 'package:chatapp/localDB/models/message_isar.dart';
import 'package:chatapp/localDB/provider/isar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

final messageStreamProvider = StreamProvider.family<List<MessagesIsar>,String>((ref,receiverId){
  final isar = ref.read(isarProvider);
  return isar.messagesIsars.filter().receiverIdEqualTo(receiverId).sortByCreatedAt().watch(fireImmediately: true);
});
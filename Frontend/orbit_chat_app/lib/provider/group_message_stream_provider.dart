
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:orbit_chat_app/localDB/model/message_isar.dart';
import 'package:orbit_chat_app/localDB/provider/isar_provider.dart';

final groupMessageStreamProvider = StreamProvider.family.autoDispose<List<MessageIsar>,String>((ref,chatId){
  final isar = ref.read(isarProvider);
  return isar.messageIsars.filter().chatIdEqualTo(chatId).watch(fireImmediately: true);
});
import 'package:chatapp/localDB/model/message_isar.dart';
import 'package:chatapp/localDB/provider/isar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

final groupMessageStreamProvider = StreamProvider.family.autoDispose<List<MessageIsar>,String>((ref,chatId){
  final isar = ref.read(isarProvider);
  return isar.messageIsars.filter().chatIdEqualTo(chatId).watch(fireImmediately: true);
});
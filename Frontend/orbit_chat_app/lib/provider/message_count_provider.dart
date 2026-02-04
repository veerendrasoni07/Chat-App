import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_chat_app/localDB/model/message_isar.dart';
import 'package:orbit_chat_app/localDB/provider/isar_provider.dart';

final messageCountProvider = StateProvider<int>((ref){
  final isar = ref.read(isarProvider);
  return isar.messageIsars.countSync();
});
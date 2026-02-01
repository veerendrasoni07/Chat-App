
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_chat_app/controller/message_controller.dart';
import 'package:orbit_chat_app/localDB/provider/isar_provider.dart';
import 'package:orbit_chat_app/localDB/service/isar_service.dart';
import 'package:orbit_chat_app/repository/message_repo.dart';

final messageRepoProvider = Provider((ref){
  final isar = ref.read(isarProvider);
  return MessageRepo( MessageService(), IsarService(isar));
});
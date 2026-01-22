

import 'package:chatapp/controller/message_controller.dart';
import 'package:chatapp/localDB/provider/isar_provider.dart';
import 'package:chatapp/localDB/service/isar_service.dart';
import 'package:chatapp/repository/message_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageRepoProvider = Provider((ref){
  final isar = ref.read(isarProvider);
  return MessageRepo( MessageService(), IsarService(isar));
});
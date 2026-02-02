import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_chat_app/localDB/provider/isar_provider.dart';
import 'package:orbit_chat_app/localDB/service/isar_service.dart';

final isarServiceProvider = Provider((ref){
  return IsarService(ref.read(isarProvider));
});
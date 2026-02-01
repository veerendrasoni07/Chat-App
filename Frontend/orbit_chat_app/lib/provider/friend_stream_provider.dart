
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:orbit_chat_app/localDB/model/user_isar.dart';
import 'package:orbit_chat_app/localDB/provider/isar_provider.dart';

final friendStreamProvider = StreamProvider<List<UserIsar>>((ref){
  final isar = ref.read(isarProvider);
  return isar.userIsars.where().watch(fireImmediately: true);
});
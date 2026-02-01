
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:orbit_chat_app/localDB/model/group_isar.dart';
import 'package:orbit_chat_app/localDB/provider/isar_provider.dart';

final groupStreamProvider = StreamProvider<List<GroupIsar>>((ref){
  final isar = ref.read(isarProvider);
  return isar.groupIsars.where().watch(fireImmediately: true);
});
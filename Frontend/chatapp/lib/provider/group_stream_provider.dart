
import 'package:chatapp/localDB/model/group_isar.dart';
import 'package:chatapp/localDB/provider/isar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

final groupStreamProvider = StreamProvider<List<GroupIsar>>((ref){
  final isar = ref.read(isarProvider);
  return isar.groupIsars.where().watch(fireImmediately: true);
});
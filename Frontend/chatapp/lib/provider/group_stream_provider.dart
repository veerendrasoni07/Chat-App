

import 'package:demo_isar_app/isar/model/group_isar.dart';
import 'package:demo_isar_app/isar/model/user_isar.dart';
import 'package:demo_isar_app/provider/isar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

final groupStreamProvider = StreamProvider<List<GroupIsar>>((ref){
  final isar = ref.read(isarProvider);
  return isar.groupIsars.where().watch(fireImmediately: true);
});
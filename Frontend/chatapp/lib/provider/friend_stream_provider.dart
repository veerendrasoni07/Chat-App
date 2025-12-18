

import 'package:chatapp/localDB/model/user_isar.dart';
import 'package:chatapp/localDB/provider/isar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

final friendStreamProvider = StreamProvider<List<UserIsar>>((ref){
  final isar = ref.read(isarProvider);
  return isar.userIsars.where().watch(fireImmediately: true);
});


import 'package:demo_isar_app/isar/service/isar_service.dart';
import 'package:demo_isar_app/provider/isar_provider.dart';
import 'package:demo_isar_app/repository/group_repo.dart';
import 'package:demo_isar_app/service/group_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupRepoProvider = Provider<GroupRepo>((ref){
  final isar = ref.read(isarProvider);
  return GroupRepo(GroupApiService(), IsarService(isar));
});
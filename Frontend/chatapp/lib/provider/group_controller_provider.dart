
import 'package:chatapp/localDB/service/isar_service.dart';
import 'package:chatapp/repository/group_repo.dart';
import 'package:chatapp/service/group_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localDB/provider/isar_provider.dart';

final groupRepoProvider = Provider<GroupRepo>((ref){
  final isar = ref.read(isarProvider);
  return GroupRepo(GroupApiService(), IsarService(isar));
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_chat_app/localDB/service/isar_service.dart';
import 'package:orbit_chat_app/repository/group_repo.dart';
import 'package:orbit_chat_app/service/group_api_service.dart';

import '../localDB/provider/isar_provider.dart';

final groupRepoProvider = Provider<GroupRepo>((ref){
  final isar = ref.read(isarProvider);
  return GroupRepo(GroupApiService(), IsarService(isar),ref);
});
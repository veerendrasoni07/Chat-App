

import 'package:chatapp/service/backend_sync_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'friend_controller_provider.dart';
import 'group_controller_provider.dart';

final backendSyncProvider = Provider<BackendSyncService>((ref){
  final _groupRepo = ref.read(groupRepoProvider);
  final _friendRepo = ref.read(friendRepoProvider);
  return BackendSyncService(_groupRepo, _friendRepo);
});
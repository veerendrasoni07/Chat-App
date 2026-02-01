
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_chat_app/localDB/provider/isar_provider.dart';
import 'package:orbit_chat_app/localDB/service/isar_service.dart';
import 'package:orbit_chat_app/repository/friend_repo.dart';

import '../service/friend_api_service.dart';

final friendRepoProvider = Provider<FriendRepo>((ref){
  return FriendRepo(IsarService(ref.read(isarProvider)), FriendApiService(),ref);
});
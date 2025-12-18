import 'package:chatapp/localDB/provider/isar_provider.dart';
import 'package:chatapp/localDB/service/isar_service.dart';
import 'package:chatapp/repository/friend_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/friend_api_service.dart';

final friendRepoProvider = Provider<FriendRepo>((ref){
  return FriendRepo(IsarService(ref.read(isarProvider)), FriendApiService());
});
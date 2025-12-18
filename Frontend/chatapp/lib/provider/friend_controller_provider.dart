import 'package:demo_isar_app/isar/service/isar_service.dart';
import 'package:demo_isar_app/provider/isar_provider.dart';
import 'package:demo_isar_app/repository/friend_repo.dart';
import 'package:demo_isar_app/service/friend_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final friendRepoProvider = Provider<FriendRepo>((ref){
  return FriendRepo(IsarService(ref.read(isarProvider)), FriendApiService());
});
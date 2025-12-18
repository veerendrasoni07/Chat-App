
import 'package:chatapp/localDB/Mapper/mapper.dart';
import 'package:chatapp/localDB/service/isar_service.dart';
import 'package:chatapp/service/friend_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendRepo {
  IsarService _isarService;
  FriendApiService _friendApiService;
  FriendRepo(this._isarService,this._friendApiService);

  Future<void> syncAllFriends()async{
    final friends = await _friendApiService.getAllFriends(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4ZDNlYzEwYjQ4Mjc4MTNiY2UzNzc4MyIsImlhdCI6MTc2NTYzNzIwMH0.T9Ud2fzEKzhYB6jHDjjLaC2G6FAbZ_LIIukl-JLr-Zc");
    final isarUsers = mapUsersToIsar(friends);
    await _isarService.saveAllFriends(isarUsers);
  }



}
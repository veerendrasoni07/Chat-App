
import 'package:chatapp/localDB/Mapper/mapper.dart';
import 'package:chatapp/localDB/service/isar_service.dart';
import 'package:chatapp/service/friend_api_service.dart';
import 'package:chatapp/utils/manage_http_request.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendRepo {
  IsarService _isarService;
  FriendApiService _friendApiService;
  FriendRepo(this._isarService,this._friendApiService);

  Future<void> syncAllFriends()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    final friends = await _friendApiService.getAllFriends(token:token!);
    final isarUsers = mapUsersToIsar(friends);
    await _isarService.saveAllFriends(isarUsers);
  }


  Future<void> removeFriend({required String friendId,required BuildContext context})async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    await _friendApiService.removeFriend(token:token!,friendId: friendId);
    await _isarService.removeFriendFromIsar(friendId: friendId);
    if(context.mounted){
      showSnackBar(context, "Friend Removed Successfully");
    }
  }



}
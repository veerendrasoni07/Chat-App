



import 'package:chatapp/localDB/service/isar_service.dart';
import 'package:chatapp/service/group_api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupRepo {
  GroupApiService _groupApiService;
  IsarService _isarService;
  GroupRepo(this._groupApiService,this._isarService);

  Future<void> syncAllGroups()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    final groups = await _groupApiService.getAllGroups(token:token!);
    await _isarService.saveAllGroups(groups);
  }

  Future<void> addMembersToTheGroup(List<String> members,String groupId,BuildContext context)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    await _groupApiService.addFriendsToGroup(members: members, groupId: groupId, token: token!, context: context);
    await _isarService.addMembersToTheGroup(groupId, members);
  }

  Future<void> removeMembersFromTheGroup(List<String> members,String groupId,BuildContext context)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    await _groupApiService.removeFriendsFromTheGroup(members: members, groupId: groupId, token: token!, context: context);
    await _isarService.removeMembersFromGroup(groupId, members);
  }

}
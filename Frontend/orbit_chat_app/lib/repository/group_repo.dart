
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_chat_app/localDB/service/isar_service.dart';
import 'package:orbit_chat_app/service/group_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupRepo {
  GroupApiService _groupApiService;
  IsarService _isarService;
  Ref ref;
  GroupRepo(this._groupApiService,this._isarService,this.ref);


  Future<void> syncAllGroups(WidgetRef ref,BuildContext context)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    final groups = await _groupApiService.getAllGroups(token:token!,ref: ref,context: context);
    await _isarService.saveAllGroups(groups);
  }

  Future<void> addMembersToTheGroup(List<String> members,String groupId,BuildContext context,WidgetRef ref)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    await _groupApiService.addFriendsToGroup(members: members, groupId: groupId, token: token!, context: context,ref: ref);
    await _isarService.addMembersToTheGroup(groupId, members);
  }

  Future<void> removeMembersFromTheGroup(List<String> members,String groupId,BuildContext context,WidgetRef ref)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    await _groupApiService.removeFriendsFromTheGroup(members: members, groupId: groupId, token: token!, context: context,ref: ref);
    await _isarService.removeMembersFromGroup(groupId, members);
  }

}
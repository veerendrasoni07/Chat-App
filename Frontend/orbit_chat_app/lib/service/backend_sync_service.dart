


import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_chat_app/repository/friend_repo.dart';
import 'package:orbit_chat_app/repository/group_repo.dart';

class BackendSyncService {

  FriendRepo _friendRepo;
  GroupRepo _groupRepo;
  Ref ref;
  BackendSyncService(this._groupRepo,this._friendRepo,this.ref);

  Future<void> backendSync({required WidgetRef ref,required BuildContext context})async{
    try{
     //await _groupRepo.syncAllGroups(ref,context);
     await _friendRepo.syncAllFriends(context: context,ref: ref);
     //await _friendRepo.getAllRecentActivities(ref: ref, context: context);
    }catch(e){

    }
  }



}
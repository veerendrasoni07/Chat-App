

import 'package:chatapp/repository/friend_repo.dart';
import 'package:chatapp/repository/group_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BackendSyncService {

  FriendRepo _friendRepo;
  GroupRepo _groupRepo;
  Ref ref;
  BackendSyncService(this._groupRepo,this._friendRepo,this.ref);

  Future<void> backendSync()async{
    try{
     await _groupRepo.syncAllGroups(ref);
     await _friendRepo.syncAllFriends();
    }catch(e){

    }
  }



}
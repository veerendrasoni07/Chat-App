

import 'package:chatapp/repository/friend_repo.dart';
import 'package:chatapp/repository/group_repo.dart';

class BackendSyncService {

  FriendRepo _friendRepo;
  GroupRepo _groupRepo;

  BackendSyncService(this._groupRepo,this._friendRepo);

  Future<void> backendSync()async{
    try{
     await _groupRepo.syncAllGroups();
     await _friendRepo.syncAllFriends();
    }catch(e){

    }
  }



}
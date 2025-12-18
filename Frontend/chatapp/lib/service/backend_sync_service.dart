import 'package:demo_isar_app/repository/friend_repo.dart';
import 'package:demo_isar_app/repository/group_repo.dart';
import 'package:demo_isar_app/service/friend_api_service.dart';
import 'package:demo_isar_app/service/group_api_service.dart';

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
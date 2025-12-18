

import 'package:demo_isar_app/isar/service/isar_service.dart';
import 'package:demo_isar_app/service/group_api_service.dart';

class GroupRepo {
  GroupApiService _groupApiService;
  IsarService _isarService;
  GroupRepo(this._groupApiService,this._isarService);

  Future<void> syncAllGroups()async{
    final groups = await _groupApiService.getAllGroups("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4ZDNlYzEwYjQ4Mjc4MTNiY2UzNzc4MyIsImlhdCI6MTc2NTYzNzIwMH0.T9Ud2fzEKzhYB6jHDjjLaC2G6FAbZ_LIIukl-JLr-Zc");
    await _isarService.saveAllGroups(groups);
  }


}
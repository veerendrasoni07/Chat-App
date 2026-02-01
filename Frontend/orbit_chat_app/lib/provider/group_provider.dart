
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_chat_app/localDB/provider/isar_provider.dart';
import 'package:orbit_chat_app/localDB/service/isar_service.dart';
import 'package:orbit_chat_app/models/group.dart';
import 'package:orbit_chat_app/provider/socket_provider.dart';
import 'package:orbit_chat_app/service/socket_service.dart';

class GroupProvider extends StateNotifier<List<Group>>{
  final SocketService service;
  final IsarService _isarService;
  GroupProvider(this.service,this._isarService):super([]){
    addGroup();
  }


  void addGroup(){
    service.newGroupCreated((data){
      print("Received group data: $data (${data.runtimeType})");
      final group = Group.fromMap(data);
      _isarService.syncSingleGroup(group);
    });
  }






}

final groupProvider = StateNotifierProvider<GroupProvider,List<Group>>((ref)=>GroupProvider(ref.read(socketProvider),IsarService(ref.read(isarProvider))));
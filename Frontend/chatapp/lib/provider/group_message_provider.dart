import 'package:chatapp/controller/group_controller.dart';
import 'package:chatapp/models/group_message.dart';
import 'package:chatapp/provider/socket_provider.dart';
import 'package:chatapp/service/socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupMessageProvider extends StateNotifier<List<GroupMessage>> {
  final GroupController controller;
  final SocketService service;
  final String groupId;
  GroupMessageProvider(this.controller, this.service,this.groupId) :super([]){
    listenGroupMessage();
  }

  Future<void> sendGroupMessage({required String senderId,required String message}) async {
    try {
      print(groupId);
      service.sendGroupMessage(groupId, senderId, message);

    }
    catch (e) {
      throw Exception('Failed to send message ${e}');
    }
  }



  void listenGroupMessage() {
    service.listenGroupMessage((data) {
      print(data);
      final msg = GroupMessage.fromMap(data);
      state = [...state, msg];
    });
  }



}

final groupMessageProvider = StateNotifierProvider.family<GroupMessageProvider,List<GroupMessage>,String>((ref,groupId){
  final service = ref.read(socketProvider);
  return GroupMessageProvider(GroupController(), service,groupId);
});


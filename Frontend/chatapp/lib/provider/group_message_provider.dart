import 'package:chatapp/controller/group_controller.dart';
import 'package:chatapp/localDB/provider/isar_provider.dart';
import 'package:chatapp/localDB/service/isar_service.dart';
import 'package:chatapp/models/group_message.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/provider/socket_provider.dart';
import 'package:chatapp/service/socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupMessageProvider extends StateNotifier<List<Message>> {
  final GroupController controller;
  final SocketService service;
  final IsarService _isarService;
  final String groupId;
  GroupMessageProvider(this.controller, this.service,this._isarService,this.groupId) :super([]){
    listenGroupMessage();
    // getAllGroupMessage();
    // groupMessageSeenStatus();
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
      print("Group msg sun rha hun main ");
      print(data);
      final msg = Message.fromMap(data);
      if(msg.receiverId == groupId){
        state = [...state, msg];
       //_isarService.saveGroupMessage(msg);
      }
    });
  }

  // void groupMessageSeenStatus(){
  //   service.groupMessageSeen((data){
  //     final userId = data['userId'];
  //     if (userId == null) return;
  //
  //     // Update only messages that did not already contain this user in seenBy.
  //     state = [
  //       for (final msg in state)
  //         msg.seenBy.any((u) => u.id == userId)
  //             ? msg
  //             : msg.copyWith(seenBy: [...msg.seenBy, userId])
  //     ];
  //   });
  // }


  // void getAllGroupMessage(){
  //   controller.getAllGroupMessages(groupId: groupId).then((value) {
  //     state = value;
  //   });
  // }



}

final groupMessageProvider = StateNotifierProvider.autoDispose.family<GroupMessageProvider,List<Message>,String>((ref,groupId){
  final service = ref.read(socketProvider);
  return GroupMessageProvider(GroupController(), service,IsarService(ref.read(isarProvider)),groupId);
});


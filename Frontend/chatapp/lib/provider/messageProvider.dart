import 'dart:convert';
import 'package:chatapp/controller/message_controller.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/provider/socket_provider.dart';
import 'package:chatapp/service/socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageProvider extends StateNotifier<List<Message>> {
  final MessageController controller;
  final String receiverId;
  final SocketService socket;
  bool _isChatOpen = false;
  MessageProvider(this.controller, this.receiverId, this.socket) : super([]) {
    getMessages();
    listenMessage();
  }

  Future<void> getMessages() async {
    print(receiverId);
    final messages = await controller.getMessages(receiverId: receiverId);
    state = messages;
  }

  // Future<void> sendMessage({required String userMessage}) async {
  //   final message = await controller.sendMessage(
  //       message: userMessage, receiverId: receiverId);
  //   state = [...state, message];
  // }

  Future<void> sendMessage({required String senderId,required String receiverId,required String userMessage})async{
    try{
      socket.sendMessage(receiverId, senderId, userMessage);
    }catch(e){
      throw Exception(e.toString());
    }
  }

  // void listenMessage() {
  //   socket.listenMessage('newMessage', (data) {
  //     final msg = jsonDecode(jsonEncode(data));
  //     var message = Message.fromMap(msg);
  //     if(message.senderId == receiverId){
  //       socket.markAsSeen(message.id);
  //       message = message.copyWith(status: 'seen');
  //     }
  //     state = [...state, message];
  //   });
  //
  //   // listen for status updates
  //   socket.listenMessageStatus((data){
  //     final status = data['status'];
  //     final messageId = data['messageId'];
  //     updateMessageStatus(messageId, status);
  //   });
  // }
  void listenMessage() {
    socket.listenMessage('newMessage', (data) {
      print("🔥 Incoming newMessage: $data");
      var message = Message.fromMap(data);

      // Only mark as seen if it's from the person this chat is open with
      if (message.senderId == receiverId) {
        if(_isChatOpen){
          socket.markAsSeen(message.id);
          message = message.copyWith(status: 'seen');
        }
        else{
          message = message.copyWith(status: 'delivered');
        }
      }

      state = [...state, message];
    });
    // Listen for message status updates (delivered/seen)
    socket.listenMessageStatus((data) {
      final messageId = data['messageId'];
      final status = data['status'];
      updateMessageStatus(messageId, status);
    });
  }


  void updateMessageStatus(String messageId, String status) {
    state = state.map((msg) {
      if (msg.id == messageId) {
        return msg.copyWith(status: status);
      }
      return msg;
    }).toList();
  }

  void chatOpened(String userId) {
    _isChatOpen = true;
    socket.chatOpen(userId, receiverId);
    for (final msg in state) {
      if (msg.senderId == receiverId && msg.status != 'seen') {
        socket.markAsSeen(msg.id);
        updateMessageStatus(msg.id, 'seen');
      }
    }
    print("✅ Chat opened with $receiverId — all delivered messages marked as seen");
  }

  void chatClosed(String userId){
    _isChatOpen = false;
    socket.chatClosed(userId);
    print("🚪 Chat closed with $receiverId");
  }

}

final messageProvider =
StateNotifierProvider.family<MessageProvider, List<Message>, String>(
      (ref, receiverId) {
    final socket = ref.read(socketProvider);
    return MessageProvider(MessageController(), receiverId, socket);
  },
);

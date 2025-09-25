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

  MessageProvider(this.controller, this.receiverId, this.socket) : super([]) {
    getMessages();
    listenMessage();
  }

  Future<void> getMessages() async {
    final messages = await controller.getMessages(receiverId: receiverId);
    state = messages;
  }

  Future<void> sendMessage({required String userMessage}) async {
    final message = await controller.sendMessage(
        message: userMessage, receiverId: receiverId);
    state = [...state, message];
  }

  void listenMessage() {
    socket.listenMessage('newMessage', (data) {
      final msg = jsonDecode(jsonEncode(data));
      final message = Message.fromMap(msg);
      state = [...state, message];
    });

    // listen for status updates
    socket.listenMessageStatus((data){
      final status = data['status'];
      final messageId = data['messageId'];
      updateMessageStatus(messageId, status);
    });


  }

  void updateMessageStatus(String messageId,String status){
    state = state.map((msg){
      if(msg.id == messageId){
        return Message(
        id: msg.id,
        senderId: msg.senderId,
        receiverId: msg.receiverId,
        message: msg.message,
        status: status,
          createdAt: msg.createdAt
        );
      }
      return msg;
    }).toList();
  }

}

final messageProvider =
StateNotifierProvider.family<MessageProvider, List<Message>, String>(
      (ref, receiverId) {
    final socket = ref.read(socketProvider);
    return MessageProvider(MessageController(), receiverId, socket);
  },
);

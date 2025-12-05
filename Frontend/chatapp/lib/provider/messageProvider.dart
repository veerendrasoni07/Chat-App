import 'package:chatapp/controller/message_controller.dart';
import 'package:chatapp/controller/voice_service.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/provider/socket_provider.dart';
import 'package:chatapp/service/socket_service.dart';
import 'package:chatapp/service/sound_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageProvider extends StateNotifier<List<Message>> {
  final MessageController controller;
  final VoiceService _voiceService;
  final String receiverId;
  final SocketService socket;
  bool _isChatOpen = false;
  MessageProvider(this.controller, this.receiverId, this.socket, this._voiceService) : super([]) {
    getMessages();
    listenMessage();
  }

  Future<void> getMessages() async {
    print(receiverId);
    final messages = await controller.getMessages(receiverId: receiverId);
    state = messages;
  }

  Future<void> sendMessage({required String senderId,required String receiverId,required String userMessage})async{
    try{
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      final newMessage = Message(id: tempId, senderId: senderId, receiverId: receiverId, message: userMessage,type: 'text' , duration: 0.0, voiceUrl: '',status: 'sending', createdAt: DateTime.now());
      state = [...state, newMessage];
      socket.sendMessage(receiverId, senderId, userMessage);
    }catch(e){
      throw Exception(e.toString());
    }
  }

  void listenMessage() {
    socket.listenMessage('newMessage', (data) {
      var message = Message.fromMap(data);
      if (message.senderId != receiverId && message.receiverId != receiverId) {
        print("⏭️ Ignoring message not related to this chat");
        return;
      }

      // Check if this is a message we sent (replace instead of duplicate)
      final existingIndex = state.indexWhere((m) =>
      m.senderId == message.senderId &&
          m.receiverId == message.receiverId &&
          m.message == message.message &&
          m.status == 'sending'); // match the temp one we sent

      if (existingIndex != -1) {
        // Replace temp message with the real one from backend
        final updatedList = [...state];
        updatedList[existingIndex] =
            message.copyWith(status: 'sent'); // or whatever backend sends
        state = updatedList;
      } else {
        // New message from receiver
        if (message.senderId == receiverId) {
          if (_isChatOpen) {
            socket.markAsSeen(message.id);
            message = message.copyWith(status: 'seen');
          } else {
            message = message.copyWith(status: 'delivered');
          }
          SoundManager.playReceiveSound();
        }

        state = [...state, message];
      }
    });

    // Listen for message status updates
    socket.listenMessageStatus((data) {
      final messageId = data['messageId'];
      final status = data['status'];
      updateMessageStatus(messageId, status);
    });
  }


  // add a VoiceService field


// call this from UI
  Future<void> sendVoice({
    required String senderId,
    required String receiverId,
    required String filePath, // local path
    required double duration,
  }) async {
    final tempId = 'voice_${DateTime.now().millisecondsSinceEpoch}';
    final placeholder = Message(
      id: tempId,
      senderId: senderId,
      receiverId: receiverId,
      message: '', // no text
      type: 'voice',
      voiceUrl: filePath, // local path used for optimistic playback if desired
      duration: duration,
      status: 'uploading',
      createdAt: DateTime.now(),
    );

    state = [...state, placeholder];

    try {
      // upload & notify server (this will trigger server -> socket -> newMessage)
      await _voiceService.sendVoiceMessage(
        senderId: senderId,
        receiverId: receiverId,
        filePath: filePath,
      );
      // Do not update state here — wait for socket event to replace placeholder.
    } catch (e) {
      // mark placeholder failed
      state = state.map((m) {
        if (m.id == tempId) {
          return m.copyWith(status: 'failed');
        }
        return m;
      }).toList();
      rethrow;
    }
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
StateNotifierProvider.autoDispose.family<MessageProvider, List<Message>, String>(
      (ref, receiverId) {
    final socket = ref.read(socketProvider);
    return MessageProvider(MessageController(), receiverId, socket,VoiceService());
  },
);

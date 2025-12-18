import 'package:chatapp/controller/image_service.dart';
import 'package:chatapp/controller/message_controller.dart';
import 'package:chatapp/controller/voice_service.dart';
import 'package:chatapp/localDB/provider/isar_provider.dart';
import 'package:chatapp/localDB/service/isar_service.dart';

import 'package:chatapp/models/message.dart';
import 'package:chatapp/provider/socket_provider.dart';
import 'package:chatapp/service/socket_service.dart';
import 'package:chatapp/service/sound_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageProvider extends StateNotifier<List<Message>> {
  final MessageController controller;
  final VoiceService _voiceService;
  final ImageService _imageService;
  final IsarService _isarService;
  final String receiverId;
  final SocketService socket;
  bool _isChatOpen = false;
  MessageProvider(this.controller, this.receiverId, this.socket, this._voiceService,this._isarService ,this._imageService) : super([]) {
    getMessages();
    listenMessage();
  }

  Future<void> getMessages() async {
    final messages = await controller.getMessages(receiverId: receiverId,lastMessageDate: DateTime.now());
    state = messages;
  }

  Future<void> sendMessage({required String senderId,required String receiverId,required String userMessage,required double duration,required String type,required String uploadUrl})async{
    try{
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      final newMessage = Message(id: tempId, senderId: senderId, receiverId: receiverId, message: userMessage,type: type , uploadDuration: duration, uploadUrl: uploadUrl,status: 'sending', createdAt: DateTime.now());
      state = [...state, newMessage];
      socket.sendMessage(receiverId, senderId, userMessage,tempId);
    }catch(e){
      throw Exception(e.toString());
    }
  }

  void listenMessage() {

      socket.listenMessage('newMessage', (data) async{
        var message = Message.fromMap(data);

        // only messages for this chat
        if (message.senderId != receiverId &&
            message.receiverId != receiverId) return;

        // FIXED: detect placeholder (sending OR uploading)
        final existingIndex = state.indexWhere((m) =>
            m.senderId == message.senderId &&
            m.receiverId == message.receiverId &&
                m.type == message.type &&
            (m.status == 'sending' || m.status == 'uploading')
        );

        if (existingIndex != -1) {
          // replace placeholder with backend message (this has Cloudinary URL)
          final updated = [...state];
          updated[existingIndex] = message.copyWith(status: 'sent');
          state = updated;
          // _isarService.saveMessage(message);
          return;
        }

        // receiver sends new message
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
        //_isarService.saveMessage(message);
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
      uploadUrl: filePath, // local path used for optimistic playback if desired
      uploadDuration: duration,
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



  Future<void> sendImage({
    required String senderId,
    required String receiverId,
    required String filePath, // local path
    required String message,
  }) async {
    final tempId = 'image_${DateTime.now().millisecondsSinceEpoch}';
    final placeholder = Message(
      id: tempId,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      type: 'image',
      uploadUrl: filePath, // local path used for optimistic playback if desired
      status: 'uploading',
      uploadDuration: 0.0,
      createdAt: DateTime.now(),
    );

    state = [...state, placeholder];

    try {
      // upload & notify server (this will trigger server -> socket -> newMessage)
      await _imageService.sendImageMessage(
        senderId: senderId,
        receiverId: receiverId,
        filePath: filePath,
        message: message,
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
    return MessageProvider(MessageController(), receiverId, socket,VoiceService(),IsarService(ref.read(isarProvider)),ImageService());
  },
);

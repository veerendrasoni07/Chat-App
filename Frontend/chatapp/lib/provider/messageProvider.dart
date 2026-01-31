import 'dart:io';
import 'package:chatapp/controller/image_service.dart';
import 'package:chatapp/controller/message_controller.dart';
import 'package:chatapp/controller/video_service.dart';
import 'package:chatapp/controller/voice_service.dart';
import 'package:chatapp/localDB/provider/isar_provider.dart';
import 'package:chatapp/localDB/service/isar_service.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/provider/socket_provider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:chatapp/service/socket_service.dart';
import 'package:chatapp/service/sound_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class MessageProvider {
  final MessageService controller;
  final VoiceService _voiceService;
  final VideoService _videoService;
  final ImageService _imageService;
  final IsarService _isarService;
  final String senderId;
  final String receiverId;
  final SocketService socket;
  bool _isChatOpen = false;
  MessageProvider(this.controller, this.receiverId,this.senderId, this.socket, this._voiceService,this._isarService ,this._imageService,this._videoService) : super() {
    listenMessage();
    seenChat();
  }



  Future<void> sendMessage({required String senderId,required String receiverId,required String userMessage,required double duration,required String type,required String uploadUrl})async{
    try{
      final localId = const Uuid().v4();
      final newMessage = Message(id: localId, senderId: senderId, receiverId: receiverId, message: userMessage,type: type,status: 'sending', createdAt: DateTime.now());
      await _isarService.saveLocalMessage(newMessage);
      socket.sendMessage(receiverId, senderId, userMessage,localId);
    }catch(e){
      throw Exception(e.toString());
    }
  }

  void listenMessage() {

    socket.listenMessage('newMessage', (data) async {
      final message = Message.fromMap(data['newMessage']);
      final tempId = data['tempId'];

      final currentUserId = senderId; // logged-in user

      // Sender side: replace placeholder
      if (tempId != null && message.senderId == currentUserId) {
        await _isarService.replacePlaceHolder(message, tempId);
        return;
      }

      // Receiver side: save message
      if (message.receiverId == currentUserId) {
        await _isarService.saveServerMessage(message);
        SoundManager.playReceiveSound();
      }
    });



    // Listen for message status updates
    socket.listenMessageStatus((data) async{
      final messageId = data['messageId'];
      final status = data['status'];
      await _isarService.updateMessageStatus(messageId, status);
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

      status: 'uploading',
      createdAt: DateTime.now(),
    );



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

    }
  }



  Future<void> sendImage({
    required String senderId,
    required String receiverId,
    required File filePath, // local path
    required String message,
  }) async {
    final localId = const Uuid().v4();
    final placeholder = Message(
      id: localId,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      type: 'image',
      media: {
        'url': filePath.path,
        'thumbnail': filePath.path,
        'size':0,
        'width':0,
        'height':0,
      },
      status: 'uploading',
      createdAt: DateTime.now(),
    );
    await _isarService.saveLocalMessage(placeholder);
    try {
      await _imageService.sendImageMessage(
        senderId: senderId,
        receiverId: receiverId,
        filePath: filePath,
        message: message,
        localId: localId,
      );
    } catch (e) {
      rethrow;
    }
  }
  Future<void> sendVideo({
    required String senderId,
    required String receiverId,
    required File filePath, // local path
    required String message,
    required BuildContext context,
    required WidgetRef ref,
    required String thumbnail,
  }) async {
    final localId = const Uuid().v4();
    final placeholder = Message(
      id: localId,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      type: 'video',
      media: {
        'url': filePath.path,
        'thumbnail':thumbnail,
        'size':0,
        'width':0,
        'height':0,
        'duration':0.0
      },
      status: 'uploading',
      createdAt: DateTime.now(),
    );
    await _isarService.saveLocalMessage(placeholder);
    try {
      await _videoService.sendVideo(
        senderId: senderId,
        receiverId: receiverId,
        videoFile: filePath,
        message: message,
        context: context,
        ref: ref,
        localId: localId,
        thumbnailFile: thumbnail,
      );
    } catch (e) {
      rethrow;
    }
  }

  void chatOpened(String userId) {
    _isChatOpen = true;
    socket.markChatSeen(userId, receiverId);
    debugPrint("📖 Chat opened → requesting seen update");
  }

  void seenChat() {
    socket.seenChat((data) async {
      final viewerId = data['by']; // The person who just saw our messages

      // Only update our local messages if WE are the sender
      // (i.e., messages we sent TO the viewerId should now show as 'seen')
      if (viewerId == receiverId) {
        print("📖 Our messages have been seen by $receiverId");
        await _isarService.markMessagesSeen(receiverId);
      }
    });
  }

  void chatClosed(String userId){
    _isChatOpen = false;
    socket.chatClosed(userId);
    debugPrint("🚪 Chat closed with $receiverId");
  }

}

final messageProvider = Provider.family<MessageProvider, String>((ref, receiverId) {
  final socket = ref.read(socketProvider);
  final user = ref.read(userProvider)!;

  return MessageProvider(
    MessageService(),
    receiverId,
    user.id,
    socket,
    VoiceService(),
    IsarService(ref.read(isarProvider)),
    ImageService(),
    VideoService(ref: ref),
  );
});

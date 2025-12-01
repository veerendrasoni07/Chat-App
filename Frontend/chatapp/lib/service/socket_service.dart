
import 'dart:async';

import 'package:chatapp/global_variable.dart';
import 'package:chatapp/models/typing_event.dart';
import 'package:chatapp/service/sound_manager.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void initSocket(String userId) {
    socket = IO.io(
      uri,
      IO.OptionBuilder()
          .setTransports(['websocket']) // Correct transport
          .enableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print('Socket connected: ${socket.id}');
      socket.emit('join', userId); // Join user room
      setupTypingListeners();
    });

    socket.onConnectError((err) => print('Connect Error: $err'));
    socket.onError((err) => print('Socket Error: $err'));
    socket.onDisconnect((_) => print('Socket disconnected'));
  }


  void sendMessage(String receiverId,String senderId,String message){
    socket.emit('send-direct-message',{
      'senderId':senderId,
      'receiverId':receiverId,
      'message':message
    });
    SoundManager.playSendSound();
  }

  void listenMessage(String event, Function(dynamic) callback) {
    socket.on(event, callback);

  }

  void userStatus(Function (dynamic) callback){
    socket.on('userStatusChanged', callback);
  }

  void listenMessageStatus(Function (dynamic) callback){
    socket.on('messageStatus',callback);
  }

  void markAsSeen(String messageId){
    socket.emit('seenMessage', {"messageId":messageId});
    print("Mark as seen done");
  }

  void chatOpen(String userId,String chatWith){
    socket.emit('chatOpened',{'userId':userId,'chatWith':chatWith});
  }
  
  void chatClosed(String userId){
    socket.emit('chatClosed',{'userId':userId});
  }


  void currentOnlineUsers(Function (dynamic) callback){
    socket.on('currentOnlineUser', callback);
  }

  void newGroupCreated(Function (dynamic) callback){
    socket.on('group-created', callback);
  }

  void syncGroups (Function(dynamic) callback){
    socket.on('sync-groups', callback);
  }

  void joinGroup(){
    socket.on('join-group', (data){
      final groupId = data['groupId'];
      socket.emit("join-group-room", groupId);
    });
  }

  void sendGroupMessage(String groupId,String senderId,String message){
    print(message);
    socket.emit('send-group-message',{
      'groupId':groupId,
      'senderId':senderId,
      'message':message
    });
  }
  
  void listenGroupMessage(Function (dynamic) callback){
    socket.on("group-message", callback);
  }
  
  void groupMessageOpened(String userId,String groupId){
    socket.emit('group-chat-opened',{
      'userId',userId,
      'groupId',groupId
    });
  }


  // ----- request/friend helpers -----
  void sendRequest(String fromUserId, String toUserId) {
    socket.emit('send-request', {
      'fromUserId': fromUserId,
      'toUserId': toUserId,
    });
  }

  // server -> me (when I get a request)
  void receivedRequest(Function(dynamic) callback) {
    socket.on('request-received', callback);
  }

  // server -> sender (confirmation that send succeeded / to update UI for sender)
  void sentRequest(Function(dynamic) callback) {
    socket.on('request-sent', callback);
  }

  // caller -> server (I accept a request). Pass payload as map.
  void acceptRequest(Map<String, dynamic> payload) {
    socket.emit('accept-request', payload);
  }

  // server -> clients: emitted after accept flow completes
  void requestAccepted(Function(dynamic) callback) {
    socket.on('request-accepted', callback);
  }

  void requestRejected(String fromId,String toId){
    socket.emit('request-reject',{
      'fromId':fromId,
      'toId':toId
    });
  }


  // typing

  final typingStream = StreamController<TypingEvent>.broadcast();

  void setupTypingListeners() {
    socket.on("typing", (data) {
      typingStream.add(
        TypingEvent(
          senderId: data["senderId"],
          receiverId: data["receiverId"],
          isTyping: true,
        ),
      );
    });

    socket.on("stop-typing", (data) {
      typingStream.add(
        TypingEvent(
          senderId: data["senderId"],
          receiverId: data["receiverId"],
          isTyping: false,
        ),
      );
    });
  }

  void userTyping(String senderId, String receiverId) {
    socket.emit("typing", {
      "senderId": senderId,
      "receiverId": receiverId,
    });
  }

  void stopTyping(String senderId, String receiverId) {
    socket.emit("stop-typing", {
      "senderId": senderId,
      "receiverId": receiverId,
    });
  }

  

  void dispose() {
    socket.dispose();
  }
}

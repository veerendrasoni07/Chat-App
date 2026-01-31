
import 'dart:async';

import 'package:chatapp/global_variable.dart';
import 'package:chatapp/models/typing_event.dart';
import 'package:chatapp/service/sound_manager.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
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


  void sendMessage(String receiverId,String senderId,String message,String tempId){
    socket.emit('send-direct-message',{
      'senderId':senderId,
      'receiverId':receiverId,
      'message':message,
      'tempId':tempId
    });
    SoundManager.playSendSound();
  }

  void listenMessage(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }


  void listenVoiceMessage(Function(dynamic) callback){
    socket.on('new-voice-message', callback);
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


  void markChatSeen(String userId,String chatWith){
    socket.emit('mark-chat-seen',{'viewerId':userId,'chatWith':chatWith});
  }

  void chatOpen(String userId,String chatWith){
    socket.emit('chatOpened',{'userId':userId,'chatWith':chatWith});
  }

  void seenChat(Function (dynamic) callback){
    socket.on('chat-seen',callback);
  }
  
  void chatClosed(String userId){
    socket.emit('chatClosed',{'userId':userId});
  }


  void currentOnlineUsers(Function (dynamic) callback){
    socket.on('currentOnlineUser', callback);
  }

  void newGroupCreated(Function (dynamic) callback){
    socket.on('group-created', (data){
      print("Received group data: $data (${data.runtimeType})");
      final id = data['id'];
      joinGroup(id);
    });
  }

  void syncGroups (Function(dynamic) callback){
    socket.on('sync-groups', callback);
  }

  void joinGroup(String groupId){
    socket.emit("join-group-room", groupId);
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
      'userId':userId,
      'groupId':groupId
    });
  }

  void groupMessageSeen(Function (dynamic) callBack){
    socket.on('groupMessageStatus', callBack);
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

extension CallEvents on SocketService{

  // join call room
  void joinCall(String meetingId,String userId){
    socket.emit('join-call',{
      'meetingId':meetingId,
      'userId':userId
    });
  }

  void leaveCall(String meetingId,String userId){
    socket.emit('leave-call',{
      'meetingId':meetingId,
      'userId':userId
    });
  }

  void sendOffer(String targetSocketId,RTCSessionDescription sdp,String userId){
    socket.emit('offer',{
      'targetSocketId':targetSocketId,
      'sdp':sdp.toMap(),
      'from':{
        'userId':userId,
        'socketId':socket.id
      }
    });
  }

  void sendAnswer(String targetSocketId,RTCSessionDescription sdp,String userId){
    socket.emit('answer',{
      'targetSocketId':targetSocketId,
      'sdp':sdp.toMap(),
      'from':{
        'userId':userId,
        'socketId':socket.id
      }
    });
  }

  void sendICE(String targetSocketId,RTCIceCandidate candidate,String userId){
    socket.emit('ice-candidate',{
      'targetSocketId':targetSocketId,
      'candidate':{
        'candidate':candidate.candidate,
        'sdpMid':candidate.sdpMid,
        'sdpMLineIndex':candidate.sdpMLineIndex
      },
      'from':{
        'userId':userId,
        'socketId':socket.id
      }
    });
  }

  void onUserJoinedCall(Function (dynamic) callBack){
    socket.on('user-joined-call', callBack);
  }

  void onUserLeftCall(Function (dynamic) callBack){
    socket.on('user-left-call', callBack);
  }

  void onOffer(Function (dynamic) callBack){
    socket.on('offer', callBack);
  }

  void onAnswer(Function (dynamic) callBack){
    socket.on('answer', callBack);
  }
  
  void onICE(Function (dynamic) callBack){
    socket.on('ice-candidate', callBack);
  }









}




import 'package:chatapp/global_variable.dart';
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

  // username check
  void usernameCheck(String username){
    socket.emit('username-check',{
      'username':username,
    });
    listenUsernameApproval();
  }

  dynamic listenUsernameApproval(){
    socket.on('username-approval', (data){
      return data;
    });
  }
  
  

  void dispose() {
    socket.dispose();
  }
}

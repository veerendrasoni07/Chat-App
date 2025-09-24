import 'package:chatapp/global_variable.dart';
import 'package:chatapp/models/message.dart';
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

  void sendMessage(String event, Message message) {
    socket.emit(event, message.toJson());
  }

  void listenMessage(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void onlineOfflineStatus(Function (dynamic) callback){
    socket.on('onlineUser', callback);
    socket.on('offlineUser', callback);
  }

  void dispose() {
    socket.dispose();
  }
}

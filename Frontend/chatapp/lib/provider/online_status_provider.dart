import 'package:chatapp/models/user_status.dart';
import 'package:chatapp/provider/socket_provider.dart';
import 'package:chatapp/service/socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnlineOfflineStatus extends StateNotifier<Map<String,UserStatus>>{
  OnlineOfflineStatus(SocketService socket):super({}){
    socket.userStatus((data){
      final userId = data['userId'];
      final isOnline = data['isOnline'];
      final lastSeen = data['lastSeen'] != null ? DateTime.parse(data['lastSeen']) : null;
      state = {
        ...state,
        userId:UserStatus(isOnline: isOnline, lastSeen: lastSeen)
      };
    });
  }
}

final statusListener = StateNotifierProvider<OnlineOfflineStatus,Map<String,UserStatus>>((ref)=>OnlineOfflineStatus(ref.read(socketProvider)));
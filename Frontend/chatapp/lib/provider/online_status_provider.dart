import 'package:chatapp/models/user_status.dart';
import 'package:chatapp/provider/socket_provider.dart';
import 'package:chatapp/service/socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnlineOfflineStatus extends StateNotifier<Map<String,UserStatus>>{
  OnlineOfflineStatus(SocketService socket):super({}){
    socket.onlineOfflineStatus((data){
      final userId = data['userId'];

      if(data.containsKey('lastSeen')){
        final lastseen = DateTime.parse(data['lastSeen']);
        state = {
          ...state,
          userId: UserStatus(isOnline: false, lastSeen: lastseen)
        };
      }else{
        UserStatus(isOnline: true, lastSeen: null);
      }
    });
  }
}

final statusListener = StateNotifierProvider<OnlineOfflineStatus,Map<String,UserStatus>>((ref)=>OnlineOfflineStatus(ref.read(socketProvider)));
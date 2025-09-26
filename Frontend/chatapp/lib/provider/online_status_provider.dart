import 'package:chatapp/models/user_status.dart';
import 'package:chatapp/provider/socket_provider.dart';
import 'package:chatapp/service/socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnlineOfflineStatus extends StateNotifier<Map<String, UserStatus>> {
  OnlineOfflineStatus(SocketService socket) : super({}) {
    // Handle the initial list of online users
    socket.currentOnlineUsers((data) {
      final newState = Map<String, UserStatus>.from(state);
      if (data is List) {
        for (final item in data) {
          if (item is Map) {
            final id = item['userId'].toString();
            final isOnline = item['isOnline'] ?? true;
            final lastSeen = item['lastSeen'] != null ? DateTime.parse(item['lastSeen']) : null;

            newState[id] = UserStatus(isOnline: isOnline, lastSeen: lastSeen);
          }
        }
      }

      state = newState;
      print("🔥 Updated online users: $state");
    });


    // Handle real-time status updates
    socket.userStatus((data) {
      final userId = data['userId'].toString();
      final isOnline = data['isOnline'] ?? false;
      final lastSeen =
      data['lastSeen'] != null ? DateTime.parse(data['lastSeen']) : null;

      state = {
        ...state,
        userId: UserStatus(isOnline: isOnline, lastSeen: lastSeen)
      };

      print("⚡ User $userId status changed: ${isOnline ? 'Online' : 'Offline'}");
    });
  }
}

final statusListener = StateNotifierProvider<OnlineOfflineStatus,
    Map<String, UserStatus>>(
      (ref) => OnlineOfflineStatus(ref.read(socketProvider)),
);

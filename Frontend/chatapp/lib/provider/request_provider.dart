
import 'package:chatapp/models/interaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp/service/socket_service.dart';
import 'package:chatapp/provider/socket_provider.dart';

class RequestProvider extends StateNotifier<List<Interaction>> {
  final SocketService socketService;
  final String userId;

  RequestProvider(this.socketService, this.userId) : super([]) {
    _init();
  }

  void _init() {
    socketService.receivedRequest((data) {
      if (data == null) return;

      final req = Interaction.fromMap(Map<String, dynamic>.from(data));

      // Add only requests sent TO ME
      if (userId == req.toUser) {
        state = [req, ...state];
      }
    });

    socketService.requestAccepted((data) {
      if (data == null) return;

      final updated = Interaction.fromMap(Map<String, dynamic>.from(data));

      state = state.map((r) {
        if (r.id == updated.id) {
          return updated; // same request but status=accepted
        }
        return r;
      }).toList();
    });
  }

  void getAllRequest(List<Interaction> requests) {
    state = requests;
  }

  void removeByFrom(String fromId) {
    state = state.where((r) => r.id != fromId).toList();
  }
  


}

/// family so provider depends on current user id
final requestProvider =
StateNotifierProvider.family<RequestProvider, List<Interaction>, String>(
        (ref, userId) {
      final socket = ref.read(socketProvider);
      return RequestProvider(socket, userId);
    });

import 'package:chatapp/controller/friend_controller.dart';
import 'package:chatapp/models/interaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp/service/socket_service.dart';
import 'package:chatapp/provider/socket_provider.dart';

class SentRequestProvider extends StateNotifier<List<Interaction>> {
  final SocketService socketService;
  final FriendController controller;
  SentRequestProvider(this.socketService,this.controller) : super([]) {
    _listen();
  }

  void _listen() {
    // When server confirms a sent-request (so we get canonical data)
    socketService.sentRequest((data) {
      if (data == null) return;

      final request = Interaction.fromMap(Map<String, dynamic>.from(data));
      final exists = state.any((r) => r.id == request.id);

      if (!exists) {
        state = [request, ...state];
      } else {
        state = state.map((r) => r.id == request.id ? request : r).toList();
      }
    });

    socketService.requestAccepted((data) {
      if (data == null) return;

      final updated = Interaction.fromMap(Map<String, dynamic>.from(data));

      // Update the matching interaction
      state = state.map((req) {
        return req.id == updated.id ? updated : req;
      }).toList();
    });

  }


  void loadInitialData() async {
    final data = await controller.getAllSentRequests();
    state = data;
  }


  /// Optionally allow removing (when cancelled or accepted)
  void removeByTo(String toId) {
    state = state.where((r) => r.id != toId).toList();
  }
}

final sentRequestProvider =
StateNotifierProvider<SentRequestProvider, List<Interaction>>((ref) {
  final socket = ref.read(socketProvider);
  return SentRequestProvider(socket,FriendController());
});

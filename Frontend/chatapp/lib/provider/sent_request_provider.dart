import 'package:chatapp/controller/friend_controller.dart';
import 'package:chatapp/models/interaction.dart';
import 'package:chatapp/service/friend_api_service.dart';
import 'package:flutter/cupertino.dart' show BuildContext;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp/service/socket_service.dart';
import 'package:chatapp/provider/socket_provider.dart';

class SentRequestProvider extends StateNotifier<List<Interaction>> {
  final SocketService socketService;
  final FriendApiService controller;
  Ref ref;
  SentRequestProvider(this.socketService,this.controller,this.ref) : super([]) {
    _listen();
  }

  void _listen() {
    // When server confirms a sent-request (so we get canonical data)
    socketService.sentRequest((data) {
      if (data == null) return;
      final request = Interaction.fromMap(data);
      final exists = state.any((r) => r.toUser.id == request.toUser.id);
      if (!exists) {
        state = [request, ...state];
      } else {
        state = state.map((r) => r.toUser.id == request.toUser.id ? request : r).toList();
      }
    });

    socketService.requestAccepted((data) {
      if (data == null) return;

      final updated = Interaction.fromMap(Map<String, dynamic>.from(data));

      // Update the matching interaction
      state = state.map((req) {
        return req.toUser.id == updated.toUser.id ? updated : req;
      }).toList();
    });

  }


  void loadInitialData({required WidgetRef ref,required BuildContext context}) async {
    final data = await controller.getAllSentRequests(ref: ref,context:context );
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
  return SentRequestProvider(socket,FriendApiService(),ref);
});

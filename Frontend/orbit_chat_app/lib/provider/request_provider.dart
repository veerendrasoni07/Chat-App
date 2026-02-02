

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_chat_app/localDB/service/isar_service.dart';
import 'package:orbit_chat_app/models/interaction.dart';
import 'package:orbit_chat_app/models/request.dart';
import 'package:orbit_chat_app/models/user.dart';
import 'package:orbit_chat_app/provider/isar_service_provider.dart';
import 'package:orbit_chat_app/provider/socket_provider.dart';
import 'package:orbit_chat_app/service/socket_service.dart';

class RequestProvider extends StateNotifier<List<Request>> {
  final SocketService socketService;
  final String userId;
  final Ref ref;
  RequestProvider(this.socketService, this.userId,this.ref) : super([]) {
    _init();
  }

  void _init() {
    socketService.receivedRequest((data) {
      if (data == null) return;

      final req = Request.fromMap(Map<String, dynamic>.from(data));

      // Add only requests sent TO ME
      
        state = [req, ...state];
      
    });

    socketService.requestAccepted((data) {
      if (data == null) return;
      print("REquest Accepted : $data");

      final updated = User.fromMap(Map<String, dynamic>.from(data));
      ref.read(isarServiceProvider).upsertUser(updated);
    });

  }

  void getAllRequest(List<Request> requests) {
    state = requests;
  }

  void removeByFrom(String fromId) {
    state = state.where((r) => r.from!.id != fromId).toList();
  }
  


}

/// family so provider depends on current user id
final requestProvider =
StateNotifierProvider.family<RequestProvider, List<Request>, String>(
        (ref, userId) {
      final socket = ref.read(socketProvider);
      return RequestProvider(socket, userId, ref);
    });

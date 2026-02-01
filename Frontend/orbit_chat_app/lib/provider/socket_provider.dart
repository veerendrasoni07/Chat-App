
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_chat_app/provider/userProvider.dart';
import 'package:orbit_chat_app/service/socket_service.dart';

final socketProvider = Provider<SocketService>((ref)  {
  final SocketService socketService = SocketService();
  final user = ref.read(userProvider);
  socketService.initSocket(user!.id);
  ref.onDispose(
      ()=> socketService.dispose()
  );
  return socketService;
});
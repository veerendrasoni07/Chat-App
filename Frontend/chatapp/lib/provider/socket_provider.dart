

import 'package:chatapp/provider/userProvider.dart';
import 'package:chatapp/service/socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final socketProvider = Provider<SocketService>((ref)  {
  final SocketService socketService = SocketService();
  final user = ref.read(userProvider);
  socketService.initSocket(user!.id);
  ref.onDispose(
      ()=> socketService.dispose()
  );
  return socketService;
});
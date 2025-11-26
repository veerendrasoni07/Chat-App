
import 'package:chatapp/provider/socket_provider.dart';
import 'package:chatapp/service/socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TypingProvider extends StateNotifier<bool>{
  SocketService service;
  String receiverId;
  TypingProvider(this.service,this.receiverId):super(false){
    listenTyping();
    stopTyping();
  }

  void listenTyping(){
    service.listenTyping((data){
      final senderId = data['senderId'];
      if(senderId == receiverId){
        state = true;
      }
    });
  }

  void stopTyping(){
    service.listenStopTyping((data){
      final senderId = data['senderId'];
      if(senderId == receiverId){
        state = false;
      }
    });
  }

}

final typingProvider = StateNotifierProvider.family<TypingProvider,bool,String>((ref,receiverId){
  return TypingProvider(ref.read(socketProvider),receiverId);
});
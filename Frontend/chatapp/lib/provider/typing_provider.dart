
import 'package:chatapp/provider/socket_provider.dart';
import 'package:chatapp/service/socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TypingProvider extends StateNotifier<bool>{
  SocketService service;
  String receiverId;
  TypingProvider(this.service,this.receiverId):super(false){
    service.typingStream.stream.listen((event){
      print("Kuch to hora hai");
      final senderId = event.senderId;
      if(senderId == receiverId){
        state = event.isTyping;
      }
    });
  }



}

final typingProvider = StateNotifierProvider.family<TypingProvider,bool,String>((ref,receiverId){
  return TypingProvider(ref.read(socketProvider),receiverId);
});
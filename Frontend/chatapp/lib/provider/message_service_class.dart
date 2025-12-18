// import 'package:chatapp/controller/image_service.dart';
// import 'package:chatapp/controller/voice_service.dart';
// import 'package:chatapp/localDB/Mapper/mapper.dart';
// import 'package:chatapp/localDB/models/message_isar.dart';
// import 'package:chatapp/localDB/provider/isar_provider.dart';
// import 'package:chatapp/localDB/service/isar_services.dart';
// import 'package:chatapp/models/message.dart';
// import 'package:chatapp/provider/socket_provider.dart';
// import 'package:chatapp/service/socket_service.dart';
// import 'package:chatapp/service/sound_manager.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class MessageService extends StateNotifier<List<MessagesIsar>>{
//
//   final String receiverId;
//   final IsarService isarService;
//   final ImageService imageService;
//   final VoiceService voiceService;
//   final SocketService socket;
//   bool isChatOpen = false;
//   MessageService(
//       {required this.receiverId,
//         required this.isarService,
//         required this.imageService,
//         required this.voiceService,
//         required this.socket}) : super([]) {
//     listenMessage();
//   }
//
//
//
//
//
//   void listenMessage()async{
//
//     socket.listenMessage('newMessage', (data) async{
//       var message = Message.fromMap(data['newMessage']);
//       final tempId = data['tempId'];
//
//       // only messages for this chat
//       if (message.senderId != receiverId &&
//           message.receiverId != receiverId) {
//         return;
//       }
//       await isarService.replacePlaceHolder(message,tempId);
//       if(message.senderId == receiverId ){
//         if(isChatOpen){
//           socket.markAsSeen(message.id);
//           await isarService.updateMessageStatus(message.id, 'seen');
//         }
//         else{
//           await isarService.updateMessageStatus(message.id, 'delivered');
//         }
//         SoundManager.playReceiveSound();
//       }
//     });
//
//     socket.listenMessageStatus((data)async{
//       final messageId = data['messageId'];
//       final status = data['status'];
//       await isarService.updateMessageStatus(messageId, status);
//     });
//
//   }
//
//   Future<void> sendMessage({required String senderId,required String receiverId,required String message,required String type})async{
//     final temp = DateTime.now().millisecondsSinceEpoch.toString();
//   final placeHolder = Message(id: temp, senderId: senderId, receiverId: receiverId, message: message, status: 'uploading', type: 'text', uploadDuration: 0.0, uploadUrl: '', createdAt: DateTime.now());
//   await isarService.saveMessage(mapMessage(placeHolder));
//   socket.sendMessage(receiverId, senderId, message,temp);
// }
//
// Future<void> sendVoice({required String senderId,required String receiverId,required String uploadUrl,required double uploadDuration})async{
//     final temp = DateTime.now().millisecondsSinceEpoch.toString();
//     final placeHolder = Message(id:temp, senderId: senderId, receiverId: receiverId, message: '', status: 'uploading', type: 'voice', uploadDuration: uploadDuration, uploadUrl: uploadUrl, createdAt: DateTime.now());
//     await isarService.saveMessage(mapMessage(placeHolder));
//     await voiceService.sendVoiceMessage(
//       senderId: senderId,
//       receiverId: receiverId,
//       filePath: uploadUrl,
//     );
//   }
//
//
//   Future<void> sendImage({required String senderId,required String receiverId,required String message,required double uploadDuration,required String uploadUrl})async{
//     final temp = DateTime.now().millisecondsSinceEpoch.toString();
//     final placeHolder = Message(id: temp ,senderId: senderId, receiverId: receiverId, message: message, status: 'uploading', type: 'image', uploadDuration: uploadDuration, uploadUrl: uploadUrl, createdAt: DateTime.now());
//     await isarService.saveMessage(mapMessage(placeHolder));
//     await imageService.sendImageMessage(
//       senderId: senderId,
//       receiverId: receiverId,
//       filePath: uploadUrl,
//       message: message,
//     );
//   }
//
//
//   Future<void> chatOpened(String userId)async {
//     isChatOpen = true;
//     socket.chatOpen(userId, receiverId);
//   }
//   Future<void> chatClosed(String userId)async{
//     isChatOpen = false;
//     socket.chatClosed(userId);
//
//   }
//
//
//
// }
// final messageServiceProvider = StateNotifierProvider.family((ref,receiverId){
//   final socket = ref.watch(socketProvider);
//   final isar = ref.watch(isarProvider);
//   return MessageService(socket: socket, receiverId: '', isarService: IsarService(isar), imageService: ImageService(), voiceService: VoiceService());
// });

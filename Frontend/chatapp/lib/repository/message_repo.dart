import 'package:chatapp/controller/message_controller.dart';
import 'package:chatapp/localDB/service/isar_service.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/provider/next_cursor_provider.dart';
import 'package:chatapp/provider/tokenProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

class MessageRepo {
  IsarService _service;
  MessageService messageService;

  MessageRepo(this.messageService,this._service);


  Future<void> fetchMessageFromBackend({required String receiverId,required String senderId,required WidgetRef ref,required BuildContext con})async {
    try{
      final cursor = ref.read(nextCursorProvider)?.cursor;
      if(cursor == null) return;
      print("Cursor:$cursor");
      final messages = await messageService.syncMessages(receiverId: receiverId,senderId: senderId ,ref:ref,context: con ,cursor: cursor);
      print(messages);
      print("Cursor is null");

    }catch(e){
      throw Exception(e.toString());
    }
  }

  Future<void> initialSync(String receiverId,String senderId,WidgetRef ref, BuildContext context) async {
    final messages = await messageService.syncMessages(
      receiverId: receiverId,
      cursor: null, ref: ref,
      context: context,
      senderId: senderId
    );
    for(Message msg in messages){
      await _service.saveServerMessage(msg);
    }
    print("messagesssssssssssssssssssssssssssssssssssss saveddddddddddddddddddddd");
  }

}
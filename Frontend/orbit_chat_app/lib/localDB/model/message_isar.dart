
import 'package:isar/isar.dart';
import 'package:orbit_chat_app/localDB/model/media_isar.dart';
part 'message_isar.g.dart';

@collection
class MessageIsar {
  Id id = Isar.autoIncrement;
  @Index() 
  late String localMessageId;
  @Index()
  String? serverMessageId;
  late String content;
  @Index()
  late String chatId;
  List<String>? seenBy;
  MediaIsar? media;
  late String messageType;
  @Index()
  late String senderId;
  @Index()
  late String status;
  @Index()
  DateTime? localCreatedAt;
  DateTime? serverCreatedAt;
}

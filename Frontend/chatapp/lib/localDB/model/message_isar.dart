
import 'package:chatapp/localDB/model/media_isar.dart';
import 'package:isar/isar.dart';
part 'message_isar.g.dart';

@collection
class MessageIsar {
  Id id = Isar.autoIncrement;
  @Index() // ❌ NOT UNIQUE
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

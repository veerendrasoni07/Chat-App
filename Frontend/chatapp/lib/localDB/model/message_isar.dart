
import 'package:isar/isar.dart';
part 'message_isar.g.dart';

@collection
class MessageIsar{
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String messageId;
  late String content;
  @Index()
  late String chatId;
  String? mediaUrl;
  int? mediaDuration;
  late String messageType;
  late bool isOutgoing;
  @Index()
  late String senderId;
  late String status;
  @Index()
  late DateTime localCreatedAt;
  DateTime? serverCreatedAt;
}
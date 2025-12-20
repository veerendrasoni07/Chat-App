
import 'package:isar/isar.dart';
part 'message_isar.g.dart';

@collection
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
  String? mediaUrl;
  double? mediaDuration;
  late String messageType;
  @Index()
  late String senderId;
  late String status;
  @Index()
  DateTime? localCreatedAt;
  DateTime? serverCreatedAt;
}

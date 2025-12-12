
import 'package:isar/isar.dart';
part 'message_isar.g.dart';

@Collection()
class MessagesIsar{
  Id id = Isar.autoIncrement;
  late String messageId;
  late String message;
  late String senderId;
  late String receiverId;
  late String type;
  String? uploadUrl;
  double? uploadDuration;
  late String status;
  DateTime updatedAt = DateTime.now();
  late DateTime createdAt;


}
import 'package:chatapp/localDB/models/user_isar.dart';
import 'package:isar/isar.dart';

part 'group_message_isar.g.dart';

@Collection()
class GroupMessageIsar{


  Id id = Isar.autoIncrement;
  late String messageId;
  late String message;
  late String senderId;
  late String groupId;
  late String type;
  String? uploadUrl;
  double? uploadDuration;
  late String status;
  DateTime updatedAt = DateTime.now();
  late DateTime createdAt;
  final seenBy = IsarLinks<UserIsar>();

}
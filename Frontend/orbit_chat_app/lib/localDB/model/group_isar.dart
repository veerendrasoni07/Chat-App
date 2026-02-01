

import 'package:isar/isar.dart';
import 'package:orbit_chat_app/localDB/model/user_isar.dart';
part 'group_isar.g.dart';

@collection
class GroupIsar{
  Id id = Isar.autoIncrement;
  late String groupName;
  @Index(unique: true)
  late String groupId;
  final groupMembers = IsarLinks<UserIsar>();
  final groupAdmins = IsarLinks<UserIsar>();
  String? groupDescription;

}
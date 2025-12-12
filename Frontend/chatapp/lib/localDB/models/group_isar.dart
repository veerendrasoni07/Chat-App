import 'package:chatapp/localDB/models/user_isar.dart';
import 'package:isar/isar.dart';

part 'group_isar.g.dart';

@Collection()
class GroupIsar{
  Id id = Isar.autoIncrement;
  late String groupName;
  late String groupId;
  late String description;
  final groupAdmins = IsarLinks<UserIsar>();
  final groupMembers = IsarLinks<UserIsar>();
  late DateTime createdAt;
  late DateTime updatedAt;
  late String groupPic;

}
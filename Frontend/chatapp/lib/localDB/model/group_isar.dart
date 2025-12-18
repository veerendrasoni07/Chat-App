

import 'package:chatapp/localDB/model/user_isar.dart';

import 'package:isar/isar.dart';
part 'group_isar.g.dart';

@collection
class GroupIsar{
  Id id = Isar.autoIncrement;
  late String groupName;
  @Index(unique: true)
  late String groupId;
  late String groupPic;
  final groupMembers = IsarLinks<UserIsar>();
  final groupAdmins = IsarLinks<UserIsar>();
  late String groupDescription;

}

import 'package:chatapp/localDB/model/group_isar.dart';
import 'package:isar/isar.dart';
part 'user_isar.g.dart';

@collection
class UserIsar {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String userId;
  late String fullname;
  late String email;
  late String profilePic;
  late String gender;
  late String bio;
  late String phone;
  late String location;
  late bool isOnline;
  final groups = IsarLinks<GroupIsar>();
}
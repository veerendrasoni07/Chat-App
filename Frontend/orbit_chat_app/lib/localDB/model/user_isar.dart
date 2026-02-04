
import 'package:isar/isar.dart';
import 'package:orbit_chat_app/localDB/model/group_isar.dart';
part 'user_isar.g.dart';

@collection
class UserIsar {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String userId;
  late String fullname;
  late String email;
  late String gender;
  late String username;
  String? bio;
  String? phone;
  String? location;
  bool? isOnline;
  final groups = IsarLinks<GroupIsar>();
}
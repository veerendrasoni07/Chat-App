
import 'package:isar/isar.dart';

part 'user_isar.g.dart';

@Collection()
class UserIsar{

  Id id = Isar.autoIncrement;
  late String fullname;
  late String userId;
  late String userName;
  late String email;
  late String phone;
  late String  profilePic;
  late String bio;
  late String gender;
  late bool isFriend;

}
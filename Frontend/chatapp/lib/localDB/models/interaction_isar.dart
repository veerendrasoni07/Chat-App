
import 'package:chatapp/localDB/models/user_isar.dart';
import 'package:isar/isar.dart';
part 'interaction_isar.g.dart';

@Collection()
class InteractionIsar{
  Id id = Isar.autoIncrement;
  final toUser = IsarLink<UserIsar>();
  final fromUser = IsarLink<UserIsar>();
  late String status;



}
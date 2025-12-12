
import 'package:chatapp/localDB/models/group_isar.dart';
import 'package:chatapp/localDB/models/group_message_isar.dart';
import 'package:chatapp/localDB/models/message_isar.dart';
import 'package:chatapp/localDB/models/user_isar.dart';
import 'package:chatapp/models/group.dart';
import 'package:chatapp/models/group_message.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/models/user.dart';
import 'package:isar/isar.dart';

MessagesIsar mapMessage(Message message){
  return MessagesIsar()
      ..messageId = message.id
      ..senderId = message.senderId
      ..receiverId = message.receiverId
      ..message = message.message
      ..status = message.status
      ..type = message.type
      ..uploadUrl = message.uploadUrl
      ..uploadDuration = message.uploadDuration
      ..createdAt = message.createdAt!;

}

GroupMessageIsar mapGroupMessage(GroupMessage grpMessage){
  return GroupMessageIsar()
      ..groupId = grpMessage.groupId
      ..senderId = grpMessage.senderId
      ..groupId = grpMessage.groupId
      ..message = grpMessage.message
      ..type = grpMessage.type
      ..status = grpMessage.status
      ..uploadUrl = grpMessage.uploadUrl
      ..uploadDuration = grpMessage.uploadDuration;
}

UserIsar mapUser(User user){
  return UserIsar()
      ..userId = user.id
      ..userName = user.username
      ..fullname = user.fullname
      ..email = user.email
      ..phone = user.phone
      ..profilePic = user.profilePic
      ..gender = user.gender
      ..isFriend = true
      ..bio = user.bio;
}

GroupIsar mapGroup(Group group,Isar isar) {
  final grp = GroupIsar()
    ..groupName = group.groupName
    ..description = group.groupDescription
    ..groupPic = group.groupPic
    ..groupId = group.id;
  for (final u in group.groupMembers) {
    final userIsar = mapUser(u);
    isar.userIsars.putSync(userIsar);
    grp.groupMembers.add(userIsar);
  }
  for (final u in group.groupAdmin) {
    final userIsar = mapUser(u);
    isar.userIsars.putSync(userIsar);
    grp.groupAdmins.add(userIsar);
  }
  return grp;
}


// now convert isar model to class model






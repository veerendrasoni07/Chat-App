
import 'package:orbit_chat_app/localDB/model/group_isar.dart';
import 'package:orbit_chat_app/localDB/model/media_isar.dart';
import 'package:orbit_chat_app/localDB/model/message_isar.dart';
import 'package:orbit_chat_app/localDB/model/user_isar.dart';
import 'package:orbit_chat_app/models/group.dart';
import 'package:orbit_chat_app/models/message.dart';
import 'package:orbit_chat_app/models/user.dart';
import 'package:uuid/uuid.dart';




  UserIsar mapUserToIsar(User user) {
    return UserIsar()
        ..userId = user.id
        ..fullname = user.fullname
        ..email = user.email
        ..gender = user.gender
        ..bio = user.bio
        ..phone = user.phone
        ..location = user.location
        ..isOnline = user.isOnline;
  }

  List<UserIsar> mapUsersToIsar(List<User> users){
    List<UserIsar> isarUsers = [];
    isarUsers = users.map((u)=> mapUserToIsar(u)).toList();
    return isarUsers;
  }


  GroupIsar mapGroupToIsar(Group group){
    GroupIsar groupIsar = GroupIsar()
    ..groupName = group.groupName
    ..groupId = group.id
    ..groupDescription = group.groupDescription;

     groupIsar.groupMembers.addAll(mapUsersToIsar(group.groupMembers));
     groupIsar.groupMembers.addAll(mapUsersToIsar(group.groupAdmin));
     return groupIsar;
  }



  List<GroupIsar> mapGroupsToIsar(List<Group> groups){
    List<GroupIsar> isarGroups = [];
    for(final group in groups){
      isarGroups.add(mapGroupToIsar(group));
    }
    return isarGroups;
  }

  MessageIsar mapMessageToIsar(Message message){
    return MessageIsar()
        ..localMessageId = const Uuid().v4()
      ..serverMessageId = message.id
        ..senderId = message.senderId
        ..chatId = message.receiverId
        ..content = message.message
        ..media = message.media != null ?
           ( MediaIsar()
            ..url = message.media?['url']
            ..thumbnail = message.media?['thumbnail']
            ..size = message.media?['size']
            ..width = message.media?['width']
            ..height = message.media?['height']
           ): null

        ..messageType = message.type
        ..status = message.status
        ..localCreatedAt = message.createdAt ;
  }

  List<MessageIsar> mapMessagesToIsar(List<Message> messages){
    List<MessageIsar>  isarMessages = [];
    for(final message in messages){
      isarMessages.add(mapMessageToIsar(message));
    }
    return isarMessages;
  }


import 'package:chatapp/localDB/Mapper/mapper.dart';
import 'package:chatapp/localDB/models/group_isar.dart';
import 'package:chatapp/localDB/models/group_message_isar.dart';
import 'package:chatapp/localDB/models/message_isar.dart';
import 'package:chatapp/models/group.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/models/user.dart';
import 'package:isar/isar.dart';

import '../../models/group_message.dart';
import '../models/user_isar.dart';

class IsarService{

  Isar _isar;


  IsarService(this._isar);

  // save message
  Future<void> saveMessage(MessagesIsar message)async{
    await _isar.writeTxn(()async{
      _isar.messagesIsars.put(message);
    });
  }
  // save group message
  Future<void> saveGroupMessage(GroupMessage message)async{
    GroupMessageIsar isarMessage = mapGroupMessage(message);
    await _isar.writeTxn(()async{
      _isar.groupMessageIsars.put(isarMessage);
    });
  }

  // save all the friends of the user
  Future<void> saveFriends(List<User> friends)async{
    await _isar.userIsars.clear();
    await _isar.writeTxn(()async{
      for(User user in friends) {
        UserIsar isarUser = mapUser(user);
        _isar.userIsars.put(isarUser);
      }
      });
  }

  // save all the groups
  Future<void> saveGroups(List<Group> groups)async {
    await _isar.groupIsars.clear();
    await _isar.writeTxn(()async{
      for(Group group in groups) {
        GroupIsar isarGroup = mapGroup(group, _isar);
        _isar.groupIsars.put(isarGroup);
      }
    });
  }

  Future<DateTime> lastMessageDate()async{
    List<MessagesIsar> message = await _isar.messagesIsars.where().sortByCreatedAtDesc().findAll() ;
    return message.last.createdAt;
  }


  // get all personal message
  Future<List<MessagesIsar>> getAllMessagesForUser(String userId)async{
    return await _isar.messagesIsars.filter().receiverIdEqualTo(userId).sortByCreatedAt().findAll();
  }

  //get all group message
  Future<List<GroupMessageIsar>> getAllMessagesForGroup(String groupId)async{
    return await _isar.groupMessageIsars.filter().groupIdEqualTo(groupId).sortByCreatedAt().findAll();
  }

  // get all the friends
Future<List<UserIsar>> getAllFriends()async{
    return await _isar.userIsars.filter().isFriendEqualTo(true).findAll();
}

  // get all the groups


// replace the place holder
  Future<void> replacePlaceHolder(Message message,String tempId)async{
    await _isar.writeTxn(()async{
      await _isar.messagesIsars.filter().messageIdEqualTo(tempId).deleteAll();
      MessagesIsar isarMessage = mapMessage(message);
      await _isar.messagesIsars.put(isarMessage);
      return;
    });
  }

  Future<void> updateMessageStatus(String messageId, String status) async {
    final existing = await _isar.messagesIsars.filter().messageIdEqualTo(messageId).findFirst();
    if (existing == null) return;
    existing.status = status;
    existing.updatedAt = DateTime.now();
    await saveMessage(existing);
  }





}
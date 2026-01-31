import 'package:chatapp/localDB/Mapper/mapper.dart';
import 'package:chatapp/localDB/model/group_isar.dart';
import 'package:chatapp/localDB/model/media_isar.dart';
import 'package:chatapp/localDB/model/message_isar.dart';
import 'package:chatapp/localDB/model/user_isar.dart';
import 'package:chatapp/models/group.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/service/socket_service.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

class IsarService {


  final Isar _isar;
  IsarService(this._isar);

  Future<void> saveAllFriends(List<UserIsar> friends) async {
    await _isar.writeTxn(() async {
      for (final user in friends) {
        final existing = await _isar.userIsars
            .filter()
            .userIdEqualTo(user.userId)
            .findFirst();

        if (existing != null) {
          user.id = existing.id; // THIS is the key
        }

        await _isar.userIsars.put(user);
      }
    });
  }

  // remove friend
  Future<void> removeFriendFromIsar({required String friendId})async{
    await _isar.writeTxn(()async{
      UserIsar? user = await _isar.userIsars.filter().userIdEqualTo(friendId).findFirst();;
      if(user != null){
        await _isar.userIsars.delete(user.id);
      }
    });
  }


  Future<UserIsar> upsertUser(User user) async {
    final existing = await _isar.userIsars
        .filter()
        .userIdEqualTo(user.id)
        .findFirst();

    if (existing != null) {
      existing
        ..fullname = user.fullname
        ..email = user.email
        ..profilePic = user.profilePic
        ..gender = user.gender
        ..bio = user.bio
        ..phone = user.phone
        ..location = user.location
        ..isOnline = user.isOnline;

      await _isar.userIsars.put(existing);
      return existing;
    }

    final u = UserIsar()
      ..userId = user.id
      ..fullname = user.fullname
      ..email = user.email
      ..profilePic = user.profilePic
      ..gender = user.gender
      ..bio = user.bio
      ..phone = user.phone
      ..location = user.location
      ..isOnline = user.isOnline;

    await _isar.userIsars.put(u);
    return u;
  }


  Future<GroupIsar> upsertGroup(Group group) async {
    final existing = await _isar.groupIsars
        .filter()
        .groupIdEqualTo(group.id)
        .findFirst();

    if (existing != null) {
      existing
        ..groupName = group.groupName
        ..groupPic = group.groupPic
        ..groupDescription = group.groupDescription;

      await _isar.groupIsars.put(existing);
      return existing;
    }

    final g = GroupIsar()
      ..groupId = group.id
      ..groupName = group.groupName
      ..groupPic = group.groupPic
      ..groupDescription = group.groupDescription;
    print("------------------------group is added to the local db----------------------------");
    await _isar.groupIsars.put(g);
    return g;
  }



  Future<void> saveAllGroups(List<Group> groups)async{
    await _isar.writeTxn(()async{
      for(final group in groups){
         await syncSingleGroup(group);
      }
    });
  }

  Future<void> syncSingleGroup(Group group) async {
    final groupIsar = await upsertGroup(group);

    // CLEAR OLD LINKS
    groupIsar.groupMembers.clear();
    groupIsar.groupAdmins.clear();

    // MEMBERS (DEDUP)
    for (final member in group.groupMembers.toSet()) {
      final userIsar = await upsertUser(member);
      groupIsar.groupMembers.add(userIsar);
    }

    // ✅ ADMINS (DEDUP)
    for (final admin in group.groupAdmin.toSet()) {
      final adminIsar = await upsertUser(admin);
      groupIsar.groupAdmins.add(adminIsar);
    }

    await groupIsar.groupMembers.save();
    await groupIsar.groupAdmins.save();
  }

  Future<void> removeMembersFromGroup(String groupId,List<String> members)async{
    await _isar.writeTxn(()async {
      final group = await _isar.groupIsars.filter().groupIdEqualTo(groupId).findFirst();
      if(group == null) return;
      for(final member in members) {
        final user = await _isar.userIsars.filter().userIdEqualTo(member).findFirst();
        if(user == null) return;
        group.groupMembers.remove(user);
      }
      await group.groupMembers.save();
    });
  }

  Future<void> addMembersToTheGroup(String groupId,List<String> members){
    return _isar.writeTxn(()async{
      final group = await _isar.groupIsars.filter().groupIdEqualTo(groupId).findFirst();
      if(group == null) return;
      for(final member in members){
        final user = await _isar.userIsars.filter().userIdEqualTo(member).findFirst();
        if(user == null) return;
        group.groupMembers.add(user);
      }
      await group.groupMembers.save();
    });
  }


  // ------Messages--------

  Future<void> saveLocalMessage(Message message) async {
    await _isar.writeTxn(() async {
      final exists = await _isar.messageIsars
          .filter()
          .localMessageIdEqualTo(message.id)
          .findFirst();

      if (exists != null) return;

      final isarMessage = MessageIsar()
        ..localMessageId = message.id
        ..senderId = message.senderId
        ..chatId = message.receiverId
        ..content = message.message
        ..media = message.media != null ?
              (
                  MediaIsar()
                  ..url = message.media?['url']
                  ..thumbnail = message.media?['thumbnail']
                  ..size = message.media?['size']
                  ..width = message.media?['width']
                  ..height = message.media?['height']
                  ..duration = message.media?['duration']
              ) : null
        ..messageType = message.type
        ..status = 'sending'
        ..localCreatedAt = message.createdAt ?? DateTime.now();

      await _isar.messageIsars.put(isarMessage);
    });
  }


  Future<void> saveServerMessage(Message message) async {
    await _isar.writeTxn(() async {
      // Already exists by server ID → ignore
      final byServerId = await _isar.messageIsars
          .filter()
          .serverMessageIdEqualTo(message.id)
          .findFirst();

      if (byServerId != null) return;

      // Check placeholder by temp/local ID
      final placeholder = await _isar.messageIsars
          .filter()
          .localMessageIdEqualTo(message.id)
          .findFirst();

      if (placeholder != null) {
        placeholder
          ..serverMessageId = message.id
          ..status = message.status
          ..content = message.message
          ..media = message.media != null ?
          (
              MediaIsar()
                ..url = message.media?['url']
                ..thumbnail = message.media?['thumbnail']
                ..size = message.media?['size']
                ..width = message.media?['width']
                ..height = message.media?['height']
                ..duration = message.media?['duration']
          ) : null
          ..serverCreatedAt = message.createdAt;

        await _isar.messageIsars.put(placeholder);
        return;
      }

      // New incoming message
      final isarMessage = MessageIsar()
        ..localMessageId = const Uuid().v4()
        ..serverMessageId = message.id
        ..senderId = message.senderId
        ..chatId = message.receiverId
        ..content = message.message
        ..messageType = message.type
        ..media = message.media != null ?
            (
                MediaIsar()
                ..url = message.media?['url']
                ..thumbnail = message.media?['thumbnail']
                ..size = message.media?['size']
                ..width = message.media?['width']
                ..height = message.media?['height']
                ..duration = message.media?['duration']
            ) : null
        ..status = message.status
        ..serverCreatedAt = message.createdAt
        ..localCreatedAt = DateTime.now();

      await _isar.messageIsars.put(isarMessage);
    });
  }



  // exist or not
  Future<MessageIsar?> isExist(String localId) async {
    return await _isar.messageIsars
        .where()
        .localMessageIdEqualTo(localId)
        .findFirst();
  }


  Future<void> replacePlaceHolder(Message message, String localId) async {
    await _isar.writeTxn(() async {
      final existing = await isExist(localId);
      if (existing == null) return;

      final alreadyExists = await _isar.messageIsars
          .filter()
          .serverMessageIdEqualTo(message.id)
          .findFirst();

      if (alreadyExists != null) return;

      existing
        ..serverMessageId = message.id
        ..status = message.status
        ..content = message.message
        ..media = message.media != null ?
        (
            MediaIsar()
              ..url = message.media?['url']
              ..thumbnail = message.media?['thumbnail']
              ..size = message.media?['size']
              ..width = message.media?['width']
              ..height = message.media?['height']
              ..duration = message.media?['duration']
        ) : null
        ..serverCreatedAt = message.createdAt;

      await _isar.messageIsars.put(existing);
    });
  }


  Future<void> updateMessageStatus(String serverId, String status) async {
    await _isar.writeTxn(() async {
      final message = await _isar.messageIsars
          .where()
          .serverMessageIdEqualTo(serverId)
          .findFirst();
      if (message != null) {
        message.status = status;
        await _isar.messageIsars.put(message);
      }
    });
  }
  Future<List<String>> updateListOfMessageStatus(String status,String receiverId,SocketService socket)async{
    final unreadMessages = await _isar.messageIsars.filter().senderIdEqualTo(receiverId).statusEqualTo('delivered').findAll();
    List<String> messageIds = [];
    await _isar.writeTxn(()async {
      for(final message in unreadMessages){
        message.status = status;
        messageIds.add(message.serverMessageId!);
        await _isar.messageIsars.put(message);
      }
    });
    return messageIds;
  }

  Future<void> deleteAllData()async{
    await _isar.writeTxn(()async{
      await _isar.userIsars.clear();
      await _isar.groupIsars.clear();
      await _isar.messageIsars.clear();
      await _isar.clear();
    });
  }


  Future<DateTime> lastMessageDate(String chatId,String senderId)async{
    return await _isar.messageIsars.filter().group((q){
      return q.senderIdEqualTo(senderId).and().chatIdEqualTo(chatId)
          .or()
          .senderIdEqualTo(chatId).and().chatIdEqualTo(senderId);
    }).sortByServerCreatedAtDesc().findFirst().then((value) => value?.serverCreatedAt ?? DateTime.now());
  }

  Future<void> clearAllMessage({required String chatId,required String senderId})async{
    await _isar.writeTxn(()async{
      return await _isar.messageIsars.filter().group((q){
        return q.senderIdEqualTo(chatId).or().chatIdEqualTo(chatId).
        and().senderIdEqualTo(senderId).or().chatIdEqualTo(senderId);
      }).deleteAll();
    });
  }

  Future<void> markMessagesSeen(String senderId) async {
    await _isar.writeTxn(() async {
      final messages = await _isar.messageIsars
          .filter()
          .senderIdEqualTo(senderId)
          .findAll();
      final messagesToUpdate = messages
          .where((m) => m.status != 'seen')
          .toList();
      for (final m in messagesToUpdate) {
        m.status = 'seen';
      }
      await _isar.messageIsars.putAll(messagesToUpdate);
    });
  }



}
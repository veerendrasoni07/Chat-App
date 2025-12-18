
import 'package:chatapp/localDB/model/group_isar.dart';
import 'package:chatapp/localDB/model/user_isar.dart';
import 'package:chatapp/models/group.dart';
import 'package:chatapp/models/user.dart';
import 'package:isar/isar.dart';

class IsarService {


  Isar _isar;
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

    await _isar.groupIsars.put(g);
    return g;
  }



  Future<void> saveAllGroups(List<Group> groups)async{
    await _isar.writeTxn(()async{
      for(final group in groups){
         await _syncSingleGroup(group);
      }
    });
  }

  Future<void> _syncSingleGroup(Group group) async {
    final groupIsar = await upsertGroup(group);

    // 🔥 CLEAR OLD LINKS (MANDATORY)
    groupIsar.groupMembers.clear();
    groupIsar.groupAdmins.clear();

    // ✅ MEMBERS (DEDUP)
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









}
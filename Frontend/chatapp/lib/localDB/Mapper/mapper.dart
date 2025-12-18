import 'package:demo_isar_app/isar/model/group_isar.dart';
import 'package:demo_isar_app/isar/model/user_isar.dart';
import 'package:demo_isar_app/model/group.dart';
import 'package:demo_isar_app/model/user.dart';





  UserIsar mapUserToIsar(User user) {
    return UserIsar()
        ..userId = user.id
        ..fullname = user.fullname
        ..email = user.email
        ..profilePic = user.profilePic
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
    ..groupPic = group.groupPic
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






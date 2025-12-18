import 'package:chatapp/localDB/model/group_isar.dart';
import 'package:chatapp/localDB/model/user_isar.dart';
import 'package:chatapp/models/group.dart';
import 'package:chatapp/models/user.dart';





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






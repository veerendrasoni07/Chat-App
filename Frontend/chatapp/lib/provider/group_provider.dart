//
//
// import 'package:chatapp/models/group.dart';
// import 'package:chatapp/provider/socket_provider.dart';
// import 'package:chatapp/service/socket_service.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class GroupProvider extends StateNotifier<List<Group>>{
//   final SocketService service;
//   GroupProvider(this.service):super([]){
//     syncGroups();
//     addGroup();
//     joinGroup();
//   }
//
//
//   void addGroup(){
//     service.newGroupCreated((data){
//       print("Received group data: $data (${data.runtimeType})");
//       final group = Group.fromMap(data);
//       state = [group,...state];
//     });
//   }
//
//   void joinGroup(){
//     service.joinGroup();
//   }
//
//   void syncGroups(){
//     service.syncGroups((data){
//       print("These are the groups that we have connected");
//       print(data);
//       // data is already List<dynamic>
//       final List<Group> groups = (data as List<dynamic>)
//           .map((group) => Group.fromMap(Map<String, dynamic>.from(group)))
//           .toList();
//       state = groups;
//     });
//   }
//
//
//
// }
//
// final groupProvider = StateNotifierProvider<GroupProvider,List<Group>>((ref)=>GroupProvider(ref.read(socketProvider)));
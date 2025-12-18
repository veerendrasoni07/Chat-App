import 'package:chatapp/localDB/Mapper/mapper.dart';
import 'package:chatapp/localDB/provider/isar_provider.dart';
import 'package:chatapp/localDB/service/isar_service.dart';
import 'package:chatapp/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendProvider extends StateNotifier<List<User>>{
  final IsarService _isarService;
  FriendProvider(this._isarService):super([]);

  void setAllFriends(List<User> friends){
    state = friends;
    _isarService.saveAllFriends(mapUsersToIsar(friends));
  }

}
final friendsProvider = StateNotifierProvider<FriendProvider,List<User>>((ref)=>FriendProvider(IsarService(ref.read(isarProvider))));
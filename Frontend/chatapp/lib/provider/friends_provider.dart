import 'package:chatapp/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendProvider extends StateNotifier<List<User>>{
  FriendProvider():super([]);

  void setAllFriends(List<User> friends){
    state = friends;
  }

}
final friendsProvider = StateNotifierProvider<FriendProvider,List<User>>((ref)=>FriendProvider());
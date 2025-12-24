import 'package:chatapp/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProvider extends StateNotifier<User?>{
  UserProvider():super(null);

  void addUser(String userJson){
    state = User.fromJson(userJson);
    print("User provider State");
    print(state);
  }

  void signOut(){
    state = null;
  }

}
final userProvider = StateNotifierProvider<UserProvider,User?>((ref)=>UserProvider());
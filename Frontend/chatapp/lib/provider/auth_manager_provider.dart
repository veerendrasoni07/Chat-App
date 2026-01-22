import 'package:chatapp/localDB/provider/isar_provider.dart';
import 'package:chatapp/localDB/service/isar_service.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus{
  unknown,
  unauthenticated,
  authenticated;
}

class AuthManagerProvider extends StateNotifier<AuthStatus>{
  Ref ref;
  AuthManagerProvider(this.ref):super(AuthStatus.unknown){
    init();
  }


  void init()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('refreshToken');
    String? user = preferences.getString('user');
    if(user != null) ref.read(userProvider.notifier).addUser(user);
    state = token == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
  }

  void setAuthenticated(){
    state = AuthStatus.authenticated;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await IsarService(ref.read(isarProvider)).deleteAllData();
    ref.read(userProvider.notifier).signOut();
    state = AuthStatus.unauthenticated;
  }
}

final authManagerProvider = StateNotifierProvider<AuthManagerProvider,AuthStatus>((ref)=> AuthManagerProvider(ref));
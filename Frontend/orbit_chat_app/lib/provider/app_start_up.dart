import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppStartUp extends StateNotifier<bool>{
  AppStartUp():super(false);
  void appStartUp(){
    state = true;
  }
}

final appStartUpProvider = StateNotifierProvider<AppStartUp,bool>((ref){
  return AppStartUp();
});
import 'package:chatapp/controller/friend_controller.dart';
import 'package:chatapp/models/interaction.dart';
import 'package:chatapp/provider/friend_controller_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityProvider extends StateNotifier<List<Interaction>>{
  Ref ref;
  ActivityProvider(this.ref):super([]){
    setActivity();
  }


  void setActivity()async{
    final activities = await ref.read(friendRepoProvider).getAllRecentActivities();
    state = activities;
  }


}
final activityProvider = StateNotifierProvider<ActivityProvider,List<Interaction>>((ref)=>ActivityProvider(ref));
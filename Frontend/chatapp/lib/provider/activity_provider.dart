import 'package:chatapp/controller/friend_controller.dart';
import 'package:chatapp/models/interaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityProvider extends StateNotifier<List<Interaction>>{

  ActivityProvider():super([]){
    setActivity();
  }


  void setActivity()async{
    final activities = await FriendController().getAllRecentActivities();
    state = activities;
  }


}
final activityProvider = StateNotifierProvider<ActivityProvider,List<Interaction>>((ref)=>ActivityProvider());
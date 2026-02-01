
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_chat_app/models/interaction.dart';

class ActivityProvider extends StateNotifier<List<Interaction>>{
  ActivityProvider():super([]);


  // void setActivity({required WidgetRef ref,required BuildContext context})async{
  //   final activities = await ref.read(friendRepoProvider).getAllRecentActivities(ref: ref,context: context);
  //   state = activities;
  // }


}
final activityProvider = StateNotifierProvider<ActivityProvider,List<Interaction>>((ref)=>ActivityProvider());

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_chat_app/localDB/Mapper/mapper.dart';
import 'package:orbit_chat_app/localDB/service/isar_service.dart';
import 'package:orbit_chat_app/models/user.dart';
import 'package:orbit_chat_app/service/friend_api_service.dart';
import 'package:orbit_chat_app/utils/manage_http_request.dart';


class FriendRepo {
  IsarService _isarService;
  Ref ref;
  FriendApiService _friendApiService;

  FriendRepo(this._isarService, this._friendApiService, this.ref);

  Future<void> syncAllFriends({required WidgetRef ref,required BuildContext context}) async {
  
    final friends = await _friendApiService.getAllFriends(
        ref: ref,context: context
    );
    final isarUsers = mapUsersToIsar(friends);
    await _isarService.saveAllFriends(isarUsers);
  }


  Future<void> removeFriend({required String friendId,required WidgetRef ref,required BuildContext context}) async {
    await _friendApiService.removeFriend(
        friendId: friendId, ref: ref,context: context);
    await _isarService.removeFriendFromIsar(friendId: friendId);
    showSnackBar(context, "Friend removed successfully");
  }


  Future<void> getAllRequests({required WidgetRef ref,required BuildContext context}) async {
    await _friendApiService.getAllRequests(ref: ref,context: context);
  }

  Future<List<User>> searchUser({required String username}) async {
    return await _friendApiService.searchUser(username: username);
  }


  // Future<List<Interaction>> getAllSentRequests({required WidgetRef ref,required BuildContext context}) async {
  //   return await _friendApiService.getAllSentRequests(ref: ref,context: context);
  // }

  // Future<void> getAllRecentActivities({required WidgetRef ref,required BuildContext context}) async {
  //    final requests = await _friendApiService.getAllRecentActivities(ref: ref,context: context);
  //    ref.read(requestProvider(ref.read(userProvider)!.id).notifier).getAllRequest(requests);
  // }


  Future<User> getUserById({required String userId}) async {
    return await _friendApiService.getUserById(userId: userId);
  }


}





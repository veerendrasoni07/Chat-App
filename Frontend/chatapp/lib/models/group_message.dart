// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:chatapp/models/user.dart';

class GroupMessage {
  final String id;
  final String groupId;
  final String senderId;
  final String message;
  final List<User> seenBy;
  final DateTime createdAt;

  GroupMessage({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.message,
    required this.seenBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'groupId': groupId,
      'senderId': senderId,
      'message': message,
      'seenBy': seenBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory GroupMessage.fromMap(Map<String, dynamic> map) {
    return GroupMessage(
      id: map['_id']?.toString() ?? '',
      groupId: map['groupId']?.toString() ?? '',
      senderId: map['senderId']?.toString() ?? '',
      message: map['message']?.toString() ?? '',
      seenBy: (map['seenBy'] as List?)
          ?.map((e) => User.fromMap(e))
          .toList()
          ?? [],

      createdAt:map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupMessage.fromJson(String source) => GroupMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  GroupMessage copyWith({ String? id,String? groupId ,String? senderId, String? message, List<User>? seenBy ,DateTime? createdAt}){
    return GroupMessage(
        id: id ?? this.id,
        senderId: senderId ?? this.senderId,
        message: message ?? this.message,
        seenBy: seenBy ?? this.seenBy,
        groupId: groupId ?? this.groupId,
        createdAt: createdAt ?? this.createdAt
    );
  }



}

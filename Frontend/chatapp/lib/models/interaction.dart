// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:chatapp/models/user.dart';

class Interaction {
  final String id;
  final User fromUser;
  final User toUser;
  final String status;

  Interaction({required this.id,required this.fromUser, required this.toUser, required this.status});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id':id,
      'fromUser': fromUser.toMap(),
      'toUser': toUser.toMap(),
      'status': status,
    };
  }

  factory Interaction.fromMap(Map<String, dynamic> map) {
    return Interaction(
      id: map['_id']?.toString() ?? '',
      fromUser: User.fromMap(map['fromUser'] as Map<String, dynamic>) ,
      toUser: User.fromMap(map['toUser'] as Map<String, dynamic>),
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Interaction.fromUserJson(String source) =>
      Interaction.fromMap(json.decode(source) as Map<String, dynamic>);
}

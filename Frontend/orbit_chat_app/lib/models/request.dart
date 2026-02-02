// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:orbit_chat_app/models/user.dart';

class Request {

  final User? from;
  final String status;
  final DateTime createdAt;
  Request({required this.from, required this.status,required this.createdAt});


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'from': from,
      'status': status,
      'createdAt':createdAt
    };
  }

  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      from: map['fromUserDetails'] != null ? User.fromMap(map['fromUserDetails']) :null ,
      status: map['status']?.toString() ?? "",
      createdAt: DateTime.parse(map['createdAt'].toString())
    );
  }

  String toJson() => json.encode(toMap());

  factory Request.fromJson(String source) => Request.fromMap(json.decode(source) as Map<String, dynamic>);
}

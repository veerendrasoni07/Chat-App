// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String type;
  final double uploadDuration;
  final String uploadUrl;
  final String message;
  final String status;
  final DateTime? createdAt;

  Message({required this.id, required this.senderId, required this.receiverId, required this.message,required this.status,required this.type,required this.uploadDuration,required this.uploadUrl,required this.createdAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'status':status,
      'type':type,
      'uploadDuration':uploadDuration,
      'uploadUrl':uploadUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: (map['_id'] ?? map['id'] ?? '').toString(),
      senderId: (map['senderId'] ?? '').toString(),
      receiverId: (map['receiverId'] ?? '').toString(),
      message: (map['message'] ?? '').toString(),
      status: (map['status'] ?? 'sent').toString(),
      type: (map['type'] ?? '').toString(),
      uploadDuration: (map['uploadDuration'] ?? 0.0) as double,
      uploadUrl: (map['uploadUrl'] ?? '').toString(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }


  Message copyWith({ String? id, String? senderId, String? receiverId, String? message, String? status, String? type, double? uploadDuration, String? uploadUrl, DateTime? createdAt}){
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
        status: status ?? this.status,
        type: type ?? this.type,
        uploadDuration: uploadDuration ?? this.uploadDuration,
        uploadUrl: uploadUrl ?? this.uploadUrl,
        createdAt: createdAt ?? this.createdAt
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source) as Map<String, dynamic>);
}

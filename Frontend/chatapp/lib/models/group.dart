// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Group {
  final String id;
  final String groupName;
  final String groupId;
  final List<String> groupMembers;
  final List<String> groupAdmin;
  final String groupDescription;

  Group({
    required this.id,
    required this.groupName,
    required this.groupId,
    required this.groupMembers,
    required this.groupAdmin,
    required this.groupDescription,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'groupName': groupName,
      'groupId': groupId,
      'groupMembers': groupMembers,
      'groupAdmin': groupAdmin,
      'groupDescription': groupDescription,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    final members = (map['groupMembers'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList() ??
        [];

    final admins = (map['groupAdmin'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList() ??
        [];
    return Group(
      id: map['_id'] ?? '',
      groupName: map['groupName'] ?? '',
      groupId: map['groupId'] ?? '',
      groupMembers: members,
      groupAdmin: admins,
      groupDescription: map['groupDescription'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(String source) => Group.fromMap(json.decode(source) as Map<String, dynamic>);
}


import 'dart:convert';


class User {
  final String id;
  final String fullname;
  final String email;
  final String gender;
  final String bio;
  final String phone;
  final String location;
  final String createdAt;
  final List<String> connections;
  final String username;
  final bool isOnline;

  User({required this.id,required this.fullname,required this.bio ,required this.email, required  ,required this.phone , required this.gender,required this.username,required this.isOnline,required this.location,required this.connections,required this.createdAt});


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullname': fullname,
      'email': email,
      'gender': gender,
      'bio':bio,
      'phone':phone,
      'isOnline':isOnline,
      'createdAt':createdAt,
      'location':location,
      'username':username,
      'connections':connections
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      fullname: map['fullname'] ?? '',
      email: map['email'] ?? '',
      gender: map['gender'] ?? '',
      phone: map['phone']?.toString() ?? '',
      bio: map['bio']?.toString() ?? '',
      isOnline: map['isOnline'] ?? false,
      createdAt: map['createdAt']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      username: map['username']?.toString() ?? '',
      connections: List<String>.from(map['connections'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}


import 'dart:convert';


class User {
  final String id;
  final String fullname;
  final String email;
  final String profilePic;
  final String gender;
  final String token;
  final String bio;
  final String phone;
  final String location;

  final List<String> connections;
  final String username;
  final bool isOnline;

  User({required this.id,required this.fullname,required this.bio ,required this.email, required this.phone ,required this.profilePic, required this.gender,required this.username,required this.token,required this.isOnline,required this.location,required this.connections});


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullname': fullname,
      'email': email,
      'profilePic': profilePic,
      'gender': gender,
      'bio':bio,
      'token':token,
      'phone':phone,
      'isOnline':isOnline,
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
      profilePic: map['profilePic'] ?? '',
      gender: map['gender'] ?? '',
      phone: map['phone'] ?? '',
      token: map['token'] ?? '',
      bio: map['bio'] ?? '',
      isOnline: map['isOnline'] ?? false,
      location: map['location'] ?? '',
      username: map['username'] ?? '',
      connections: List<String>.from(map['connections'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}

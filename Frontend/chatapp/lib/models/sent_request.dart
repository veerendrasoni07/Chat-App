// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SentRequest {

  final String to;
  final String status;
  final String fullname;
  final String image;

  SentRequest({required this.to, required this.status, required this.fullname, required this.image});


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'to': to,
      'status': status,
      'fullname': fullname,
      'image': image,
    };
  }

  factory SentRequest.fromMap(Map<String, dynamic> map) {
    return SentRequest(
      to: map['to']?.toString() ?? "",
      status: map['status']?.toString() ?? "",
      fullname: map['fullname']?.toString() ?? "",
      image: map['image']?.toString() ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory SentRequest.fromJson(String source) => SentRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}

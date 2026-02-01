// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Request {

  final String from;
  final String status;
  final String fullname;
  final String image;

  Request({required this.from, required this.status, required this.fullname, required this.image});


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'from': from,
      'status': status,
      'fullname': fullname,
      'image': image,
    };
  }

  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      from: map['from']?.toString() ?? "",
      status: map['status']?.toString() ?? "",
      fullname: map['fullname']?.toString() ?? "",
      image: map['image']?.toString() ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Request.fromJson(String source) => Request.fromMap(json.decode(source) as Map<String, dynamic>);
}

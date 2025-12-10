
import 'package:isar/isar.dart';

part 'message_mode.g.dart';

class Messages{

  final String message;
  final String senderId;
  final String receiverId;
  final String type;
  final String voiceUrl;
  final double duration;
  final String status;

  Messages({required this.message, required this.senderId, required this.receiverId, required this.type, required this.voiceUrl, required this.duration, required this.status});

}
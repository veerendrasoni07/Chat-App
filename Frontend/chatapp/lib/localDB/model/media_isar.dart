import 'package:isar/isar.dart';

part 'media_isar.g.dart';

@embedded
class MediaIsar {
  String? url;
  String? thumbnail;
  int? size;
  int? width;
  int? height;
  String? localPath; // for upload retry
}

class ChatTileData {
  final String id;         // userId or groupId
  final String name;       // friend name OR group name
  final bool isGroup;
  final DateTime lastMessageTime;
  final int unreadCount;

  ChatTileData({
    required this.id,
    required this.name,
    required this.isGroup,
    required this.lastMessageTime,
    required this.unreadCount,
  });
}

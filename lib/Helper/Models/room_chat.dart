class RoomChat {
  final String id;
  final String name;
  final String createdBy;
  final int createdAt;
  final Map<String, bool> members;

  RoomChat({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.createdAt,
    required this.members,
  });

  factory RoomChat.fromMap(Map<dynamic, dynamic> map, String id) {
    return RoomChat(
      id: id,
      name: map['name'] ?? '',
      createdBy: map['createdBy'] ?? '',
      createdAt: map['createdAt'] ?? 0,
      members: Map<String, bool>.from(map['members'] ?? {}),
    );
  }
}

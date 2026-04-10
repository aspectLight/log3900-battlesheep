class FriendRequest {
  const FriendRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
  });

  final String id;
  final String senderId;
  final String receiverId;
  final String status;

  factory FriendRequest.fromJson(Map<String, dynamic> json) => FriendRequest(
    id: json['_id'] as String,
    senderId: json['senderId'] as String,
    receiverId: json['receiverId'] as String,
    status: json['status'] as String? ?? '',
  );
}

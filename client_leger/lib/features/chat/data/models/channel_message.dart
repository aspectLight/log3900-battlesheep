class ChannelMessage {
  final String channelId;
  final String senderName;
  final String content;
  final String time;
  final String? avatarId;
  final String? avatarUrl;
  final int? avatarDisplayNonce;

  const ChannelMessage({
    required this.channelId,
    required this.senderName,
    required this.content,
    required this.time,
    this.avatarId,
    this.avatarUrl,
    this.avatarDisplayNonce,
  });
}

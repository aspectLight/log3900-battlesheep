class ChannelMessage {
  final String channelId;
  final String senderName;
  final String content;
  final String time;
  final String? avatarId;
  final String? avatarUrl;

  const ChannelMessage({
    required this.channelId,
    required this.senderName,
    required this.content,
    required this.time,
    this.avatarId,
    this.avatarUrl,
  });
}

import '../models/channel_info.dart';
import '../models/channel_message.dart';

class MessagesUpdatedEvent {
  final String channelId;
  final List<ChannelMessage> messages;

  const MessagesUpdatedEvent({required this.channelId, required this.messages});
}

abstract interface class DiscussionCanalsRepository {
  Stream<List<ChannelInfo>> get channelsUpdated;
  Stream<String> get channelCreated;
  Stream<void> get channelDeleted;
  Stream<String> get channelError;
  Stream<List<String>> get joinedChannelsUpdated;
  Stream<MessagesUpdatedEvent> get messagesUpdated;

  String get currentUsername;

  void listChannels();
  void createChannel(String name);
  void deleteChannel(String channelId);
  void joinChannel(String channelId);
  void leaveChannel(String channelId);
  void sendMessage(String channelId, String content);
  List<ChannelMessage> getMessages(String channelId);
  bool isJoined(String channelId);
}

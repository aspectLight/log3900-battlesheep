import 'dart:async';

import '../../../../core/services/socket_service.dart';
import '../../domain/commands/chat_commands.dart';
import '../../domain/models/chat_message.dart';
import '../models/dto/chat_message_dto.dart';
import '../models/extensions/chat_message_dto_extensions.dart';
import '../models/events/chat_socket_events.dart';
import '../models/extensions/send_chat_emoji_command_to_dto_extensions.dart';
import '../models/extensions/send_chat_message_command_to_dto_extensions.dart';

class ChatSocket {
  final SocketService _socketService;

  final _messageController = StreamController<ChatMessage>.broadcast();
  final _historyController = StreamController<List<ChatMessage>>.broadcast();

  StreamSubscription<bool>? _connectionSub;
  StreamSubscription<ChatMessageDto>? _messageSub;
  StreamSubscription<ChatMessageDto>? _emojiSub;
  StreamSubscription<List<ChatMessageDto>>? _historySub;

  ChatSocket({required SocketService socketService})
    : _socketService = socketService {
    _connectionSub = _socketService.connectionStream.listen((connected) {
      if (connected) _setupChatListeners();
    });
    if (_socketService.isConnected) {
      _setupChatListeners();
    }
  }

  Stream<bool> get connectionStream => _socketService.connectionStream;

  Stream<Object?> get errorStream => _socketService.errorStream;

  Stream<ChatMessage> get messageStream => _messageController.stream;

  Stream<List<ChatMessage>> get historyStream => _historyController.stream;

  void _setupChatListeners() {
    unawaited(_messageSub?.cancel());
    unawaited(_emojiSub?.cancel());
    unawaited(_historySub?.cancel());
    _messageSub = _socketService
        .on<Object?>(GeneralChatEvents.generalChatMessage)
        .map(ChatMessageDto.fromSocketPayload)
        .listen(_forwardMessageToStream);
    _emojiSub = _socketService
        .on<Object?>(GeneralChatEvents.generalChatEmoji)
        .map(ChatMessageDto.fromSocketPayload)
        .listen(_forwardMessageToStream);
    _historySub = _socketService
        .on<Object?>(GeneralChatEvents.getGeneralChatMessagesResponse)
        .map(ChatMessageDto.listFromSocketPayload)
        .listen(_forwardHistoryToStream);
  }

  void _forwardMessageToStream(ChatMessageDto dto) {
    _messageController.add(dto.toModel());
  }

  void _forwardHistoryToStream(List<ChatMessageDto> dtos) {
    _historyController.add(dtos.map((d) => d.toModel()).toList());
  }

  void join(String username) {
    _socketService.emit(GeneralChatEvents.joinGeneralChat, username);
  }

  void loadMessages() {
    _socketService.emit(GeneralChatEvents.getGeneralChatMessages);
  }

  void sendMessage(SendChatMessageCommand command) {
    final payload = command.toSendMessagePayloadDto();
    _socketService.emit(
      GeneralChatEvents.sendMessageToGeneralChat,
      payload.toJson(),
    );
  }

  void sendEmoji(SendChatEmojiCommand command) {
    final payload = command.toSendEmojiPayloadDto();
    _socketService.emit(
      GeneralChatEvents.sendEmojiToGeneralChat,
      payload.toJson(),
    );
  }

  Future<void> dispose() async {
    await _connectionSub?.cancel();
    await _messageSub?.cancel();
    await _emojiSub?.cancel();
    await _historySub?.cancel();
    await _messageController.close();
    await _historyController.close();
  }
}

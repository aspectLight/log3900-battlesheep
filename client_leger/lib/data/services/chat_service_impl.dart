import '../../domain/interfaces/services/chat_service.dart';
import '../models/chat_socket_events.dart';
import './log_service.dart';
import './socket_chat_service.dart';

class ChatServiceImpl implements ChatService {
  final SocketChatServiceImpl _chatService;

  ChatServiceImpl({required SocketChatServiceImpl chatService})
    : _chatService = chatService;

  @override
  void joinGeneralChat(String username) {
    final socket = _chatService.socket;

    if (socket == null || !_chatService.isConnected) {
      LogService.w('Cannot join general chat: socket not connected');
      return;
    }

    socket.emit(GeneralChatEvents.joinGeneralChat, username);
    LogService.i('Joining general chat as $username');
  }

  @override
  void leaveGeneralChat() {
    final socket = _chatService.socket;

    if (socket == null || !_chatService.isConnected) {
      LogService.w('Cannot leave general chat: socket not connected');
      return;
    }

    socket.emit(GeneralChatEvents.leaveGeneralChat);
    LogService.i('Left general chat');
  }
}

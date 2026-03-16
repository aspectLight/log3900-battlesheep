import 'dart:async';

import '../../../../core/interfaces/event_projection.dart';
import '../repositories/chat_repository.dart';
import '../services/chat_socket.dart';

class ChatEventsProjection implements EventProjection {
  ChatEventsProjection({
    required ChatRepository chatRepository,
    required ChatSocket chatSocket,
  }) : _chatRepository = chatRepository,
       _chatSocket = chatSocket;

  final ChatRepository _chatRepository;
  final ChatSocket _chatSocket;

  @override
  List<StreamSubscription> subscribe() => [
    _chatSocket.messageStream.listen(_chatRepository.applyMessageAdded),
    _chatSocket.historyStream.listen(_chatRepository.applyHistorySet),
  ];
}

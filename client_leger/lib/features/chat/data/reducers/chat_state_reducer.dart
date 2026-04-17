import '../../domain/events/chat_events.dart';
import '../../domain/state/chat_state.dart';

class ChatStateReducer {
  ChatState reduce(ChatState previous, Object event) {
    if (event is ChatMessageAddedEvent) {
      return _reduceMessageAdded(previous, event);
    }
    if (event is ChatHistorySetEvent) {
      return _reduceHistorySet(previous, event);
    }
    if (event is ChatUsernameUpdatedEvent) {
      return _reduceUsernameUpdated(previous, event);
    }
    return previous;
  }

  ChatState _reduceMessageAdded(
    ChatState previous,
    ChatMessageAddedEvent event,
  ) {
    return previous.copyWith(messages: [...previous.messages, event.message]);
  }

  ChatState _reduceHistorySet(ChatState previous, ChatHistorySetEvent event) {
    return previous.copyWith(messages: event.messages);
  }

  ChatState _reduceUsernameUpdated(
    ChatState previous,
    ChatUsernameUpdatedEvent event,
  ) {
    final oldName = event.oldUsername;
    final newName = event.newUsername;
    if (oldName.isEmpty ||
        newName.isEmpty ||
        oldName == newName) {
      return previous;
    }
    return previous.copyWith(
      messages: previous.messages
          .map(
            (m) => m.name == oldName ? m.copyWith(name: newName) : m,
          )
          .toList(),
    );
  }
}

import 'dart:async';

import '../../../../core/interfaces/event_projection.dart';
import '../../core/event_bus/character_creation_event_bus.dart';
import '../models/extensions/update_character_reserved_payload_dto_extensions.dart';
import '../repositories/character_creation_repository.dart';
import '../services/character_creation_socket.dart';

class CharacterCreationEventsProjection implements EventProjection {
  CharacterCreationEventsProjection({
    required CharacterCreationSocket socket,
    required CharacterCreationRepository repository,
    required CharacterCreationEventBus eventBus,
  }) : _socket = socket,
       _repository = repository,
       _eventBus = eventBus;

  final CharacterCreationSocket _socket;
  final CharacterCreationRepository _repository;
  final CharacterCreationEventBus _eventBus;

  @override
  List<StreamSubscription> subscribe() => [
    _socket.roomLockedStream.listen((_) {
      _repository.applyRoomLocked(value: true);
      _eventBus.fire(const CharacterCreationRoomLockedEvent());
    }),
    _socket.reservedCharactersPayloadStream.listen((payload) {
      _repository.applyReservedCharacters(
        payload.toReservedCharacterEventList(),
      );
    }),
  ];
}

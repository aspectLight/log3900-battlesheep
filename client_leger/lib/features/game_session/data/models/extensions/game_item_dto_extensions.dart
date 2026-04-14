import '../../../domain/commands/game_item_commands.dart';
import '../../../domain/events/game_item_events.dart';
import '../../../domain/models/game_item.dart';
import 'game_board_position_dto_extensions.dart';
import '../dto/game_item_dto.dart';

extension GameItemDtoToEntity on GameItemDto {
  GameItem toEntity() => GameItem(type: type);
}

extension GameItemToDto on GameItem {
  GameItemDto toDto() => GameItemDto(type: type);
}

extension ItemDroppedCommandToDto on ItemDroppedCommand {
  ItemDroppedCommandDto toDto() {
    final playerId = switch (source) {
      PlayerItemDropSource(:final playerId) => playerId,
      DisconnectedItemDropSource() => null,
    };
    return ItemDroppedCommandDto(
      roomId: roomId,
      playerId: playerId,
      item: item.toDto(),
      coords: coords.toDto(),
    );
  }
}

extension ItemCollectedCommandToDto on ItemCollectedCommand {
  ItemCollectedCommandDto toDto() => ItemCollectedCommandDto(
    roomId: roomId,
    playerId: playerId,
    item: item.toDto(),
    position: position.toDto(),
  );
}

extension ItemCollectedDtoToEntity on ItemCollectedDto {
  ItemCollectedEvent toEntity() => ItemCollectedEvent(
    playerId: playerId,
    item: item.toEntity(),
    position: position?.toEntity(),
    inventoryFull: inventoryFull,
  );
}

extension ItemDroppedDtoToEntity on ItemDroppedDto {
  ItemDroppedEvent toEntity() => ItemDroppedEvent(
    roomId: roomId,
    playerId: playerId,
    item: item.toEntity(),
    coords: coords.toEntity(),
  );
}

extension ItemDroppedDisconnectedDtoToEntity on ItemDroppedDisconnectedDto {
  ItemDroppedDisconnectedEvent toEntity() => ItemDroppedDisconnectedEvent(
    items: items.map((d) => d.toEntity()).toList(),
    coords: coords.toEntity(),
    roomId: roomId,
  );
}

extension FlagCollectedDtoToEntity on FlagCollectedDto {
  FlagCollectedEvent toEntity() => FlagCollectedEvent(playerId: playerId);
}

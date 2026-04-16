import 'package:signals_flutter/signals_flutter.dart';

import '../../../data/repositories/game_inventory_repository.dart';
import '../../../data/repositories/game_metadata_repository.dart';
import '../../../data/repositories/game_player_repository.dart';
import '../../../data/repositories/game_turn_repository.dart';
import '../../mappers/game_player_cards_hud_ui_mapper.dart';
import '../../ui_models/components/game_player_ui_card.dart';

class GamePlayerCardsHudViewModel {
  final GamePlayerRepository _playerRepository;
  final GameTurnRepository _turnRepository;
  final GameMetadataRepository _sessionRepository;
  final GameInventoryRepository _inventoryRepository;

  late final cards = computed<List<GamePlayerUiCard>>(
    () => toGamePlayerCardsHudCards(
      _playerRepository.state.value,
      _turnRepository.state.value,
      _sessionRepository.state.value,
      _inventoryRepository.state.value,
    ),
  );

  GamePlayerCardsHudViewModel({
    required GamePlayerRepository playerRepository,
    required GameTurnRepository turnRepository,
    required GameMetadataRepository sessionRepository,
    required GameInventoryRepository inventoryRepository,
  }) : _playerRepository = playerRepository,
       _turnRepository = turnRepository,
       _sessionRepository = sessionRepository,
       _inventoryRepository = inventoryRepository;
}

import '../../domain/state/game_player_state.dart';

typedef CombatContext = ({
  String selfId,
  bool isPlayerTurn,
  bool isInitiator,
  GamePlayer enemy,
});

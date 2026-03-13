import '../../../../../core/enums/item_type.dart';
import '../../../core/extensions/item_type_ext.dart';
import '../../../core/localisation/game_session_localizations.dart';

class GamePlayerInventoryItemUi {
  final ItemType type;

  const GamePlayerInventoryItemUi({required this.type});

  String name(GameSessionLocalizations l10n) => type.getName(l10n);
  String description(GameSessionLocalizations l10n) => type.getDescription(l10n);
}

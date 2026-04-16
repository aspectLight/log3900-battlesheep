import '../../../../../core/constants/item_assets.dart';
import '../../../../../core/enums/item_type.dart';
import '../../../core/extensions/item_type_ext.dart';
import '../../../core/localisation/game_session_localizations.dart';

class GameBoardUiItem {
  final ItemType type;

  const GameBoardUiItem({required this.type});

  String name(GameSessionLocalizations l10n) => type.getName(l10n);
  String description(GameSessionLocalizations l10n) =>
      type.getDescription(l10n);

  String get imagePath => ItemAssets.gameBoardItem(type);
}

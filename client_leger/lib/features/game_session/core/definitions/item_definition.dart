import '../localisation/game_session_localizations.dart';
import '../../../../core/constants/item_assets.dart';
import '../../../../core/enums/item_type.dart';
import '../extensions/item_type_ext.dart';

class ItemDefinition {
  final ItemType type;

  const ItemDefinition._({required this.type});

  String get imagePath => ItemAssets.gameBoardItem(type);
  String name(GameSessionLocalizations l10n) => type.getName(l10n);
  String description(GameSessionLocalizations l10n) =>
      type.getDescription(l10n);

  static const _all = {
    ItemType.adrenaline: ItemDefinition._(type: ItemType.adrenaline),
    ItemType.vodka: ItemDefinition._(type: ItemType.vodka),
    ItemType.propaganda: ItemDefinition._(type: ItemType.propaganda),
    ItemType.barbedWire: ItemDefinition._(type: ItemType.barbedWire),
    ItemType.camouflage: ItemDefinition._(type: ItemType.camouflage),
    ItemType.waterproofBoots: ItemDefinition._(type: ItemType.waterproofBoots),
    ItemType.airStrike: ItemDefinition._(type: ItemType.airStrike),
    ItemType.torch: ItemDefinition._(type: ItemType.torch),
    ItemType.random: ItemDefinition._(type: ItemType.random),
    ItemType.flag: ItemDefinition._(type: ItemType.flag),
    ItemType.spawnPoint: ItemDefinition._(type: ItemType.spawnPoint),
  };

  static ItemDefinition? fromType(ItemType type) => _all[type];
}

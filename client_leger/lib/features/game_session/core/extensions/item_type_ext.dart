import '../localisation/game_session_localizations.dart';
import '../../../../core/enums/item_type.dart';

extension ItemTypeExtension on ItemType {
  String getName(GameSessionLocalizations l10n) => switch (this) {
    ItemType.adrenaline => l10n.itemAdrenalineName,
    ItemType.vodka => l10n.itemVodkaName,
    ItemType.propaganda => l10n.itemPropagandaName,
    ItemType.barbedWire => l10n.itemBarbedWireName,
    ItemType.camouflage => l10n.itemCamouflageName,
    ItemType.waterproofBoots => l10n.itemWaterproofBootsName,
    ItemType.airStrike => l10n.itemAirStrikeName,
    ItemType.random => l10n.itemRandomName,
    ItemType.flag => l10n.itemFlagName,
    ItemType.spawnPoint => l10n.itemSpawnName,
  };

  String getDescription(GameSessionLocalizations l10n) => switch (this) {
    ItemType.adrenaline => l10n.itemAdrenalineDesc,
    ItemType.vodka => l10n.itemVodkaDesc,
    ItemType.propaganda => l10n.itemPropagandaDesc,
    ItemType.barbedWire => l10n.itemBarbedWireDesc,
    ItemType.camouflage => l10n.itemCamouflageDesc,
    ItemType.waterproofBoots => l10n.itemWaterproofBootsDesc,
    ItemType.airStrike => l10n.itemAirStrikeDesc,
    ItemType.random => l10n.itemRandomDesc,
    ItemType.flag => l10n.itemFlagDesc,
    ItemType.spawnPoint => l10n.itemSpawnDesc,
  };
}

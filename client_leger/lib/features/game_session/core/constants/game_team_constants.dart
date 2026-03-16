import '../enums/team_type.dart';
import '../../../../core/constants/ui_assets.dart';

class GameTeamConstants {
  static const int teamUssr = 1;
  static const int teamUsa = 2;

  static const Map<TeamType, String> teamToDisplayName = {
    TeamType.ussr: 'USSR',
    TeamType.usa: 'USA',
  };

  static const Map<int, TeamType> intToTeam = {
    teamUssr: TeamType.ussr,
    teamUsa: TeamType.usa,
  };

  static const Map<TeamType, String> teamToBackgroundAsset = {
    TeamType.ussr: UiAssets.teamUssrBg,
    TeamType.usa: UiAssets.teamAmericanBg,
  };

  GameTeamConstants._();

  static TeamType? fromInt(int? value) =>
      value != null ? intToTeam[value] : null;

  static String? toDisplayName(int? team) {
    final type = fromInt(team);
    return type != null ? teamToDisplayName[type] : null;
  }

  static String? backgroundAssetFor(int? team) {
    final type = fromInt(team);
    return type != null ? teamToBackgroundAsset[type] : null;
  }
}

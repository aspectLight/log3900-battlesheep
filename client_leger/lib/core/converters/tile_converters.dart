import 'package:json_annotation/json_annotation.dart';

import '../../features/game_session/core/enums/tile_orientation.dart';
import '../../features/game_session/core/enums/tile_type.dart';

class TileOrientationConverter implements JsonConverter<TileOrientation?, String?> {
  const TileOrientationConverter();

  @override
  TileOrientation? fromJson(String? json) {
    if (json == null || json.isEmpty) return null;
    final lower = json.toLowerCase();
    for (final v in TileOrientation.values) {
      if (v.serverValue.toLowerCase() == lower) return v;
    }
    return null;
  }

  @override
  String? toJson(TileOrientation? object) => object?.serverValue;
}

class TileTypeConverter implements JsonConverter<TileType, String> {
  const TileTypeConverter();

  @override
  TileType fromJson(String json) =>
      TileType.values.firstWhere((e) => e.name == json);

  @override
  String toJson(TileType object) => object.name;
}

class TileStateConverter implements JsonConverter<TileState?, String?> {
  const TileStateConverter();

  @override
  TileState? fromJson(String? json) {
    if (json == null) return null;
    final match = TileState.values.where((e) => e.name == json);
    return match.isEmpty ? null : match.first;
  }

  @override
  String? toJson(TileState? object) => object?.name;
}

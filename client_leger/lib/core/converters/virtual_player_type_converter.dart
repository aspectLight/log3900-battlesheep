import 'package:json_annotation/json_annotation.dart';

import '../enums/virtual_player_type.dart';

class VirtualPlayerTypeConverter
    implements JsonConverter<VirtualPlayerType, String> {
  const VirtualPlayerTypeConverter();

  @override
  VirtualPlayerType fromJson(String json) => VirtualPlayerType.fromId(json);

  @override
  String toJson(VirtualPlayerType object) => object.id;
}

import 'package:json_annotation/json_annotation.dart';

import '../enums/item_type.dart';

class ItemTypeConverter implements JsonConverter<ItemType?, String?> {
  const ItemTypeConverter();

  @override
  ItemType? fromJson(String? json) =>
      json == null ? null : ItemType.values.firstWhere((e) => e.name == json);

  @override
  String? toJson(ItemType? object) => object?.name;
}

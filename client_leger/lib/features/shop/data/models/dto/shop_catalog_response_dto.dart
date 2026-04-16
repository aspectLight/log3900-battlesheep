import 'package:json_annotation/json_annotation.dart';

import 'shop_item_dto.dart';

part 'shop_catalog_response_dto.g.dart';

@JsonSerializable()
class ShopCatalogResponseDto {
  final bool success;

  @JsonKey(defaultValue: <ShopItemDto>[])
  final List<ShopItemDto> catalogue;

  @JsonKey(defaultValue: <String>[])
  final List<String> purchasedItems;

  final String? error;

  const ShopCatalogResponseDto({
    required this.success,
    required this.catalogue,
    required this.purchasedItems,
    this.error,
  });

  factory ShopCatalogResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ShopCatalogResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ShopCatalogResponseDtoToJson(this);
}

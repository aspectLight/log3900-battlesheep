import 'package:json_annotation/json_annotation.dart';

part 'shop_item_dto.g.dart';

@JsonSerializable()
class ShopItemDto {
  final String id;
  final String name;
  final String type;
  final int price;
  final String? imagePath;

  const ShopItemDto({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    this.imagePath,
  });

  factory ShopItemDto.fromJson(Map<String, dynamic> json) =>
      _$ShopItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ShopItemDtoToJson(this);
}

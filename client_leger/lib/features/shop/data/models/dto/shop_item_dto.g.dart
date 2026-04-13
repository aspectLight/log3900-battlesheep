// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopItemDto _$ShopItemDtoFromJson(Map<String, dynamic> json) => ShopItemDto(
  id: json['id'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  price: (json['price'] as num).toInt(),
  imagePath: json['imagePath'] as String?,
);

Map<String, dynamic> _$ShopItemDtoToJson(ShopItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'price': instance.price,
      'imagePath': instance.imagePath,
    };

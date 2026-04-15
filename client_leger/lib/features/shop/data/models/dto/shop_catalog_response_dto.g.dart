// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_catalog_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopCatalogResponseDto _$ShopCatalogResponseDtoFromJson(
  Map<String, dynamic> json,
) => ShopCatalogResponseDto(
  success: json['success'] as bool,
  catalogue:
      (json['catalogue'] as List<dynamic>?)
          ?.map((e) => ShopItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  purchasedItems:
      (json['purchasedItems'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  error: json['error'] as String?,
);

Map<String, dynamic> _$ShopCatalogResponseDtoToJson(
  ShopCatalogResponseDto instance,
) => <String, dynamic>{
  'success': instance.success,
  'catalogue': instance.catalogue,
  'purchasedItems': instance.purchasedItems,
  'error': instance.error,
};

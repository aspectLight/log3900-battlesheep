// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseResponseDto _$PurchaseResponseDtoFromJson(Map<String, dynamic> json) =>
    PurchaseResponseDto(
      success: json['success'] as bool,
      newBalance: (json['newBalance'] as num?)?.toInt(),
      purchasedItems:
          (json['purchasedItems'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      error: json['error'] as String?,
    );

Map<String, dynamic> _$PurchaseResponseDtoToJson(
  PurchaseResponseDto instance,
) => <String, dynamic>{
  'success': instance.success,
  'newBalance': instance.newBalance,
  'purchasedItems': instance.purchasedItems,
  'error': instance.error,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyResponseDto _$CurrencyResponseDtoFromJson(Map<String, dynamic> json) =>
    CurrencyResponseDto(
      success: json['success'] as bool,
      balance: (json['balance'] as num?)?.toInt(),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$CurrencyResponseDtoToJson(
  CurrencyResponseDto instance,
) => <String, dynamic>{
  'success': instance.success,
  'balance': instance.balance,
  'error': instance.error,
};

import 'package:json_annotation/json_annotation.dart';

part 'currency_response_dto.g.dart';

@JsonSerializable()
class CurrencyResponseDto {
  final bool success;
  final int? balance;
  final String? error;

  const CurrencyResponseDto({
    required this.success,
    this.balance,
    this.error,
  });

  factory CurrencyResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CurrencyResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyResponseDtoToJson(this);
}

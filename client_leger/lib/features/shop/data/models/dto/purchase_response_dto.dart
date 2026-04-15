import 'package:json_annotation/json_annotation.dart';

part 'purchase_response_dto.g.dart';

@JsonSerializable()
class PurchaseResponseDto {
  final bool success;

  final int? newBalance;

  @JsonKey(defaultValue: <String>[])
  final List<String> purchasedItems;

  final String? error;

  const PurchaseResponseDto({
    required this.success,
    this.newBalance,
    required this.purchasedItems,
    this.error,
  });

  factory PurchaseResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PurchaseResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseResponseDtoToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'purchase_item_request_dto.g.dart';

@JsonSerializable()
class PurchaseItemRequestDto {
  const PurchaseItemRequestDto({required this.itemId});

  final String itemId;

  Map<String, dynamic> toJson() => _$PurchaseItemRequestDtoToJson(this);
}

import '../../../domain/models/shop_socket_models.dart';
import '../dto/currency_response_dto.dart';

extension CurrencyResponseDtoExt on CurrencyResponseDto {
  ShopCurrencyModel toModel() =>
      ShopCurrencyModel(success: success, balance: balance, error: error);
}

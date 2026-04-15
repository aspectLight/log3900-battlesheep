import '../../../../../core/enums/shop_catalog_item_id.dart';
import '../../../domain/models/shop_socket_models.dart';
import '../dto/shop_catalog_response_dto.dart';
import 'shop_item_dto_ext.dart';

extension ShopCatalogResponseDtoExt on ShopCatalogResponseDto {
  ShopCatalogModel toModel() => ShopCatalogModel(
    success: success,
    catalogue: catalogue.map((item) => item.toModel()).toList(),
    purchasedItems: purchasedItems.map(ShopCatalogItemId.parse).toList(),
    error: error,
  );
}

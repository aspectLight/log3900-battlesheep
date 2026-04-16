import '../../../../../core/enums/shop_catalog_item_id.dart';
import '../../../../../core/enums/shop_item_type.dart';
import '../../../domain/models/shop_item_model.dart';
import '../dto/shop_item_dto.dart';

extension ShopItemDtoExt on ShopItemDto {
  ShopItemModel toModel() => ShopItemModel(
    id: ShopCatalogItemId.parse(id),
    name: name,
    type: ShopItemType.fromWire(type),
    price: price,
  );
}

import 'package:get_it/get_it.dart';

import '../../data/repositories/shop_repository.dart';
import '../../data/services/shop_socket.dart';

void registerShopRepositories(GetIt getIt) {
  getIt.registerLazySingleton<ShopRepository>(
    () => ShopRepository(shopSocket: getIt<ShopSocket>()),
  );
}

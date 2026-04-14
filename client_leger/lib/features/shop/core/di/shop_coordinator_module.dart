import 'package:get_it/get_it.dart';

import '../../../../routing/app_navigator.dart';
import '../coordinators/shop_coordinator.dart';

void registerShopCoordinator(GetIt getIt) {
  getIt.registerLazySingleton<ShopCoordinator>(
    () => ShopCoordinator(appNavigator: getIt<AppNavigator>()),
  );
}

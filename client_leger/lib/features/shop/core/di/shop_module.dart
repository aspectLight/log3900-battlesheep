import 'package:get_it/get_it.dart';

import 'shop_coordinator_module.dart';
import 'shop_repository_module.dart';
import 'shop_service_module.dart';
import 'shop_side_effect_module.dart';
import 'shop_view_model_module.dart';

void registerShopRoot(GetIt getIt) {
  registerShopViewModels(getIt);
  registerShopCoordinator(getIt);
}

void registerShopConnectedScope(GetIt scope, GetIt _) {
  registerShopServices(scope);
  registerShopRepositories(scope);
  registerShopSideEffects(scope);
}

void bootstrapShopConnectedScope(GetIt scope) {
  bootstrapShopSideEffects(scope);
}

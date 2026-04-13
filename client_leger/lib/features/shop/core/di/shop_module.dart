import 'package:get_it/get_it.dart';

import 'shop_coordinator_module.dart';
import 'shop_repository_module.dart';
import 'shop_service_module.dart';
import 'shop_side_effect_module.dart';
import 'shop_view_model_module.dart';

void registerShopRoot(GetIt getIt) {
  registerShopServices(getIt);
  registerShopRepositories(getIt);
  registerShopViewModels(getIt);
  registerShopCoordinator(getIt);
  registerShopSideEffects(getIt);
}

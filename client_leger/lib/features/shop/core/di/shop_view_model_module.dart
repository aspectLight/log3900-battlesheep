import 'package:get_it/get_it.dart';

import '../../../profile/data/services/http_profile_service.dart';
import '../../data/scoped_shop_access.dart';
import '../../presentation/screens/shop/shop_view_model.dart';

void registerShopViewModels(GetIt getIt) {
  getIt.registerFactory<ShopViewModel>(
    () => ShopViewModel(
      repository: scopedShopRepositoryOrNull(getIt)!,
      profileService: getIt<HttpProfileService>(),
    ),
  );
}

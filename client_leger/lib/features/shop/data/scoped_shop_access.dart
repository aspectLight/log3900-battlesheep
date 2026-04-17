import 'package:get_it/get_it.dart';

import '../../../core/connected_scope/session_scope_manager.dart';
import 'repositories/shop_repository.dart';

/// [ShopRepository] lives on the session [GetIt] scope, not the root container.
ShopRepository? scopedShopRepositoryOrNull(GetIt getIt) {
  final scope = getIt<SessionScopeManager>().currentScope;
  if (scope == null || !scope.isRegistered<ShopRepository>()) return null;
  return scope.get<ShopRepository>();
}

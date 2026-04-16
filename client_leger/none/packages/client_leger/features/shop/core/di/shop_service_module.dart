import 'package:get_it/get_it.dart';

import '../../../../core/services/socket_service.dart';
import '../../data/services/shop_socket.dart';

void registerShopServices(GetIt getIt) {
  getIt.registerLazySingleton<ShopSocket>(
    () => ShopSocket(socketService: getIt<SocketService>()),
    dispose: (socket) => socket.dispose(),
  );
}

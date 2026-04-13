import '../../../../core/app_transition/feature_coordinator.dart';
import '../../../../routing/app_navigator.dart';
import '../../../../routing/navigation_command.dart';
import '../app_events/shop_events.dart';

class ShopCoordinator
    implements
        FeatureCoordinator<
          ShopEntryAppEvent,
          ShopCompletedAppEvent,
          ShopExitAppEvent> {
  ShopCoordinator({required this.appNavigator});

  final AppNavigator appNavigator;

  @override
  Future<void> onEntry(ShopEntryAppEvent event) async {
    appNavigator.request(GoToShop());
  }

  @override
  Future<void> onCompleted(ShopCompletedAppEvent event) async {}

  @override
  Future<void> onExit(ShopExitAppEvent event) async {
    appNavigator.request(ExitToMainMenu());
  }
}

import 'package:get_it/get_it.dart';

import 'modal_coordinator.dart';
import 'modal_intent_sink.dart';
import 'modal_widget_registry.dart';

void registerModalModule(GetIt getIt) {
  getIt.registerLazySingleton<ModalCoordinator>(ModalCoordinator.new);
  getIt.registerLazySingleton<ModalIntentSink>(
    () => getIt<ModalCoordinator>(),
  );
  getIt.registerLazySingleton<ModalWidgetRegistry>(ModalWidgetRegistry.new);
}

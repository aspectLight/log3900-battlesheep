import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'core/app_transition/app_initialization.dart';
import 'core/app_transition/app_transition_bus.dart';
import 'core/di/injection_container.dart';
import 'core/localisation/core_localizations.dart';
import 'core/modal/modal_overlay.dart';
import 'core/notification/notification_overlay.dart';
import 'core/presentation/widgets/loading_overlay/loading_overlay.dart';
import 'core/presentation/widgets/loading_overlay/loading_overlay_view_model.dart';
import 'features/authentication/core/app_events/auth_events.dart';
import 'features/authentication/core/localisation/auth_localizations.dart';
import 'features/character_creation/core/localisation/character_creation_localizations.dart';
import 'features/chat/core/localisation/chat_localizations.dart';
import 'features/game_session/core/localisation/game_session_localizations.dart';
import 'features/join_game_session/core/localisation/join_game_session_localizations.dart';
import 'features/profile/core/localisation/profile_localizations.dart';
import 'features/select_game_session/core/localisation/select_game_session_localizations.dart';
import 'features/statistics/core/localisation/statistics_localizations.dart';
import 'features/waiting_room/core/localisation/waiting_room_localizations.dart';
import 'routing/app_router.dart';
import 'routing/app_router_observer.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> with WidgetsBindingObserver {
  late final AppRouter _appRouter;
  late final AppTransitionEventBus _appTransitionEventBus;
  late final AppInitialization _appInitialization;
  late final LoadingOverlayViewModel _loadingOverlayViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _appRouter = getIt<AppRouter>();
    _appTransitionEventBus = getIt<AppTransitionEventBus>();
    _appInitialization = getIt<AppInitialization>();
    _loadingOverlayViewModel = getIt<LoadingOverlayViewModel>();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      _appTransitionEventBus.fire(
        const AuthExitAppEvent.appLifecycleDetached(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isReady = _appInitialization.isReady.value;

      if (!isReady) {
        return const MaterialApp(
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      }

      return MaterialApp.router(
        title: 'Eastern Solace',
        debugShowCheckedModeBanner: false,
        locale: const Locale('fr'),
        routerConfig: _appRouter.config(
          navigatorObservers: () => [
            AppRouterObserver(
              loadingOverlayViewModel: _loadingOverlayViewModel,
            ),
          ],
        ),
        localizationsDelegates: const [
          CoreLocalizations.delegate,
          AuthLocalizations.delegate,
          JoinGameSessionLocalizations.delegate,
          WaitingRoomLocalizations.delegate,
          SelectGameSessionLocalizations.delegate,
          CharacterCreationLocalizations.delegate,
          GameSessionLocalizations.delegate,
          ChatLocalizations.delegate,
          StatisticsLocalizations.delegate,
          ProfileLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: CoreLocalizations.supportedLocales,
        builder: (context, child) {
          return Watch((context) {
            final isNavigating = _loadingOverlayViewModel.isNavigating.value;

            return Stack(
              children: [
                child ?? const SizedBox.shrink(),
                if (isNavigating)
                  const Positioned.fill(child: LoadingOverlay()),
                const Positioned.fill(child: NotificationOverlay()),
                const Positioned.fill(child: ModalOverlay()),
              ],
            );
          });
        },
      );
    });
  }
}

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'core/session/user_session.dart';
import 'domain/entities/auth_state.dart';
import 'generated/l10n/app_localizations.dart';
import 'presentation/widgets/loading_overlay/loading_overlay.dart';
import 'presentation/widgets/loading_overlay/loading_overlay_view_model.dart';
import 'presentation/widgets/sliding_chat_box/sliding_chat_box.dart';
import 'routing/app_router.dart';
import 'routing/app_router_observer.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late final AppRouter _appRouter;
  late final UserSession _userSession;
  EffectCleanup? _authStateCleanup;

  @override
  void initState() {
    super.initState();
    _appRouter = GetIt.I<AppRouter>();
    _userSession = GetIt.I<UserSession>();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    _authStateCleanup = effect(() {
      final state = _userSession.authState.value;

      if (state is AuthStateUnauthenticated) {
        unawaited(_appRouter.replaceAll([const AuthLandingRoute()]));
      }
    });
  }

  @override
  void dispose() {
    _authStateCleanup?.call();
    _userSession.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loadingOverlayViewModel = GetIt.I<LoadingOverlayViewModel>();

    return Watch((context) {
      final isInitialLoading = _userSession.isLoading.value;
      final isNavigating = loadingOverlayViewModel.isNavigating.value;

      if (isInitialLoading) {
        return const MaterialApp(
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      }

      final initialRoute = _getInitialRoute();

      return MaterialApp.router(
        title: 'Eastern Solace',
        debugShowCheckedModeBanner: false,
        locale: const Locale('fr'),
        routerConfig: _appRouter.config(
          deepLinkBuilder: (_) => DeepLink([initialRoute]),
          navigatorObservers: () => [
            AppRouterObserver(loadingOverlayViewModel: loadingOverlayViewModel),
          ],
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) {
          return Watch((context) {
            final currentRoute = _appRouter.currentChild?.name;
            final forbiddenRoutes = [
              AuthLandingRoute.name,
              LoginRoute.name,
              SignUpRoute.name,
            ];
            final shouldShowChat =
                currentRoute != null && !forbiddenRoutes.contains(currentRoute);

            return Stack(
              children: [
                child ?? const SizedBox.shrink(),
                if (shouldShowChat)
                  Positioned.fill(
                    child: Overlay(
                      initialEntries: [
                        OverlayEntry(
                          builder: (context) => const SlidingChatBox(),
                        ),
                      ],
                    ),
                  ),
                if (isNavigating)
                  const Positioned.fill(child: LoadingOverlay()),
              ],
            );
          });
        },
      );
    });
  }

  PageRouteInfo _getInitialRoute() {
    final state = _userSession.authState.value;
    if (state is AuthStateAuthenticated) {
      return const MainMenuRoute();
    }
    return const AuthLandingRoute();
  }
}

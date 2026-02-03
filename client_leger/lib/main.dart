import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'core/di/injection_container.dart';
import 'domain/entities/auth_state.dart';
import 'generated/l10n/app_localizations.dart';

import 'presentation/view_models/auth_view_model.dart';
import 'presentation/view_models/navigation_view_model.dart';
import 'presentation/widgets/loading_overlay.dart';
import 'routing/app_router.dart';
import 'routing/app_router_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env.dev');

  await setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppRouter _appRouter;
  late final AuthViewModel _authViewModel;
  EffectCleanup? _authStateCleanup;

  @override
  void initState() {
    super.initState();
    _appRouter = GetIt.I<AppRouter>();
    _authViewModel = GetIt.I<AuthViewModel>();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    _authStateCleanup = effect(() {
      final state = _authViewModel.authState.value;

      if (state is AuthStateUnauthenticated) {
        unawaited(_appRouter.replaceAll([const AuthLandingRoute()]));
      }
    });
  }

  @override
  void dispose() {
    _authStateCleanup?.call();
    _authViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigationViewModel = GetIt.I<NavigationViewModel>();

    return Watch((context) {
      final isInitialLoading = _authViewModel.isLoading.value;
      final isNavigating = navigationViewModel.isNavigating.value;

      if (isInitialLoading) {
        return const MaterialApp(
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      }

      final initialRoute = _getInitialRoute();

      return MaterialApp.router(
        title: 'Client Leger',
        debugShowCheckedModeBanner: false,
        locale: const Locale('fr'),
        routerConfig: _appRouter.config(
          deepLinkBuilder: (_) => DeepLink([initialRoute]),
          navigatorObservers: () => [
            AppRouterObserver(navigationViewModel: navigationViewModel),
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
          return Stack(
            children: [
              child ?? const SizedBox.shrink(),
              if (isNavigating) const Positioned.fill(child: LoadingOverlay()),
            ],
          );
        },
      );
    });
  }

  PageRouteInfo _getInitialRoute() {
    final state = _authViewModel.authState.value;
    if (state is AuthStateAuthenticated) {
      return const MainRoute();
    }
    return const AuthLandingRoute();
  }
}

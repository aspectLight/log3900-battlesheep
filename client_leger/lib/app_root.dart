import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'core/app_transition/app_initialization.dart';
import 'core/app_transition/app_transition_bus.dart';
import 'core/appearance/app_appearance_service.dart';
import 'core/appearance/app_feature_colors.dart';
import 'core/appearance/app_interaction_colors.dart';
import 'core/appearance/app_visual_theme.dart';
import 'core/constants/ui_assets.dart';
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
import 'features/shop/core/localisation/shop_localizations.dart';
import 'features/select_game_session/core/localisation/select_game_session_localizations.dart';
import 'features/statistics/core/localisation/statistics_localizations.dart';
import 'features/tutorial/core/localisation/tutorial_localizations.dart';
import 'features/waiting_room/core/localisation/waiting_room_localizations.dart';
import 'routing/app_router.dart';
import 'routing/app_router_observer.dart';

/// [MaterialApp] installs a debug [DefaultTextStyle] (red text, double yellow
/// underline) above your content. Descendant [Text] merges ambient styles with
/// the theme; **null** fields in the theme keep the debug underline metadata, and
/// `copyWith(decoration: none)` alone still leaves decoration color/style from
/// the previous style.
///
/// We merge an explicit patch and use [DefaultTextStyle.merge] in
/// `MaterialApp.builder` so the debug fallback cannot survive a merge.
TextStyle _stripDebugUnderlinePatch() => const TextStyle(
      decoration: TextDecoration.none,
      decorationColor: Color(0x00000000),
    );

TextTheme _stripMaterialDebugTextDecoration(TextTheme base) {
  final patch = _stripDebugUnderlinePatch();
  TextStyle clear(TextStyle? style) {
    if (style == null) {
      return patch;
    }
    return style.merge(patch);
  }

  return TextTheme(
    displayLarge: clear(base.displayLarge),
    displayMedium: clear(base.displayMedium),
    displaySmall: clear(base.displaySmall),
    headlineLarge: clear(base.headlineLarge),
    headlineMedium: clear(base.headlineMedium),
    headlineSmall: clear(base.headlineSmall),
    titleLarge: clear(base.titleLarge),
    titleMedium: clear(base.titleMedium),
    titleSmall: clear(base.titleSmall),
    bodyLarge: clear(base.bodyLarge),
    bodyMedium: clear(base.bodyMedium),
    bodySmall: clear(base.bodySmall),
    labelLarge: clear(base.labelLarge),
    labelMedium: clear(base.labelMedium),
    labelSmall: clear(base.labelSmall),
  );
}

ThemeData _appMaterialTheme(AppVisualTheme visual) {
  final ColorScheme scheme;
  final AppInteractionColors interaction;
  switch (visual) {
    case AppVisualTheme.defaultTheme:
      scheme = const ColorScheme.dark(
        primary: Color(0xFF550000),
        onPrimary: Color(0xFFF5E6E6),
        secondary: Color(0xFF7F1F1F),
        onSecondary: Color(0xFFF5E6E6),
        surface: Color(0xFF2B2B2B),
        onSurface: Color(0xFFF5E6E6),
        surfaceContainerHighest: Color(0xFF1A1A1A),
      );
      interaction = AppInteractionColors.defaultPalette;
    case AppVisualTheme.frost:
      scheme = const ColorScheme.dark(
        primary: Color(0xFF152535),
        onPrimary: Color(0xFFE0F2FF),
        secondary: Color(0xFF28526E),
        onSecondary: Color(0xFFE0F2FF),
        surface: Color(0xFF152535),
        onSurface: Color(0xFFD0EAF8),
        surfaceContainerHighest: Color(0xFF0E1C2C),
      );
      interaction = AppInteractionColors.frostPalette;
    case AppVisualTheme.village:
      scheme = const ColorScheme.dark(
        primary: Color(0xFF4A3018),
        onPrimary: Color(0xFFEDE4C8),
        secondary: Color(0xFF624028),
        onSecondary: Color(0xFFEDE4C8),
        surface: Color(0xFF201E17),
        onSurface: Color(0xFFDDD4AE),
        surfaceContainerHighest: Color(0xFF161410),
      );
      interaction = AppInteractionColors.villagePalette;
  }

  final featureColors = AppFeatureColors.fromVisualTheme(visual);

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.black,
    extensions: <ThemeExtension<dynamic>>[interaction, featureColors],
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.surface.withValues(alpha: 0.35);
          }
          return scheme.primary;
        }),
        foregroundColor: WidgetStatePropertyAll(scheme.onPrimary),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return null;
          return BorderSide(color: interaction.outline, width: 2);
        }),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontFamily: 'CustomFont', fontWeight: FontWeight.w600),
        ),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: scheme.surface,
      surfaceTintColor: Colors.transparent,
      textStyle: TextStyle(
        color: scheme.onSurface,
        fontFamily: 'CustomFont',
        fontSize: 16,
        decoration: TextDecoration.none,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: interaction.outline.withValues(alpha: 0.45),
      thickness: 1,
    ),
  );
  return base.copyWith(
    textTheme: _stripMaterialDebugTextDecoration(base.textTheme),
    primaryTextTheme: _stripMaterialDebugTextDecoration(base.primaryTextTheme),
  );
}

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
  bool _scheduledNavAssetPrecache = false;
  bool _syncedGuestLocaleAfterFirstReadyFrame = false;

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

  Future<void> _precacheNavTransitionAssets(BuildContext context) async {
    for (final theme in AppVisualTheme.values) {
      if (!context.mounted) return;
      await precacheImage(
        AssetImage(backgroundAssetForVisualTheme(theme)),
        context,
      );
    }
    if (!context.mounted) return;
    await precacheImage(const AssetImage(UiAssets.snow), context);
    if (!context.mounted) return;
    await precacheImage(const AssetImage(UiAssets.loading), context);
  }

  void _scheduleNavAssetPrecacheOnce() {
    if (_scheduledNavAssetPrecache) return;
    _scheduledNavAssetPrecache = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_precacheNavTransitionAssets(context));
    });
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
          debugShowCheckedModeBanner: false,
          showPerformanceOverlay: false,
          debugShowMaterialGrid: false,
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      }

      if (!_syncedGuestLocaleAfterFirstReadyFrame) {
        _syncedGuestLocaleAfterFirstReadyFrame = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          getIt<AppAppearanceService>().syncGuestLocaleFromPlatformIfNoExplicitChoice();
        });
      }

      final appearance = getIt<AppAppearanceService>();
      appearance.locale.value;
      appearance.visualTheme.value;

      return MaterialApp.router(
        title: 'Eastern Solace',
        debugShowCheckedModeBanner: false,
        showPerformanceOverlay: false,
        debugShowMaterialGrid: false,
        locale: appearance.locale.value,
        theme: _appMaterialTheme(appearance.visualTheme.value),
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
          ShopLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          TutorialLocalizations.delegate,
        ],
        supportedLocales: CoreLocalizations.supportedLocales,
        builder: (context, child) {
          _scheduleNavAssetPrecacheOnce();
          final theme = Theme.of(context);
          final body = theme.textTheme.bodyMedium!.merge(_stripDebugUnderlinePatch());
          return DefaultTextStyle.merge(
            style: body,
            child: Watch((context) {
              final isNavigating = _loadingOverlayViewModel.isNavigating.value;

              // While navigating: only [LoadingOverlay] paints (parallax + spinner).
              // Route is [Offstage] so no page UI is shown. Do not disable [TickerMode]
              // on the router during overlay: that pauses the route fade; when the
              // overlay hides the transition restarts and the previous route flashes.
              // Notification/modal stay in the tree with [Offstage] to avoid jank.
              return Stack(
                fit: StackFit.expand,
                children: [
                  Offstage(
                    offstage: isNavigating,
                    child: child ?? const SizedBox.shrink(),
                  ),
                  Positioned.fill(
                    child: Offstage(
                      offstage: isNavigating,
                      child: const NotificationOverlay(),
                    ),
                  ),
                  Positioned.fill(
                    child: Offstage(
                      offstage: isNavigating,
                      child: const ModalOverlay(),
                    ),
                  ),
                  if (isNavigating)
                    const Positioned.fill(
                      child: RepaintBoundary(
                        child: LoadingOverlay(),
                      ),
                    ),
                ],
              );
            }),
          );
        },
      );
    });
  }
}

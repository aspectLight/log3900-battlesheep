import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../features/authentication/core/interfaces/auth_repository.dart';
import '../../../../features/character_creation/core/localisation/character_creation_localizations.dart';
import '../../../../features/join_game_session/core/localisation/join_game_session_localizations.dart';
import '../../../../features/profile/core/localisation/profile_localizations.dart';
import '../../../../features/select_game_session/core/localisation/select_game_session_localizations.dart';
import '../../../../features/shop/data/repositories/shop_repository.dart';
import '../../../../features/shop/data/scoped_shop_access.dart';
import '../../../../features/shop/domain/state/shop_state.dart';
import '../../../../features/waiting_room/core/localisation/waiting_room_localizations.dart';
import '../../../../routing/app_navigator.dart';
import '../../../../routing/app_router.dart';
import '../../../../routing/navigation_command.dart';
import '../../../appearance/app_interaction_colors.dart';
import '../../../config/env_config.dart';
import '../../../connected_scope/session_scope_manager.dart';
import '../../../constants/auth_avatar_assets.dart';
import '../../../constants/ui_assets.dart';
import '../../../localisation/core_localizations.dart';
import '../../screens/main_menu/main_menu_view_model.dart';
import '../../shell/shell_chrome_back_handler.dart';
import '../../shell/shell_chrome_metrics.dart';

class ShellQuickSettingsOverlay extends StatefulWidget {
  const ShellQuickSettingsOverlay({super.key});

  @override
  State<ShellQuickSettingsOverlay> createState() =>
      _ShellQuickSettingsOverlayState();
}

class _ShellQuickSettingsOverlayState extends State<ShellQuickSettingsOverlay> {
  late final AppRouter _appRouter;
  late final MainMenuViewModel _menuViewModel;
  late final AuthRepository _authRepository;
  late final AppNavigator _appNavigator;
  late final ShellChromeBackHandler _shellBack;
  StreamSubscription? _authSubscription;
  StackRouter? _shellListenerTarget;
  bool _open = false;
  String _currentAvatarId = '';
  String? _currentAvatarUrl;
  String? _lastAuthAccountKey;

  static const _balanceTextStyle = TextStyle(
    color: Color(0xFFF0C040),
    fontSize: 15,
    fontWeight: FontWeight.bold,
    fontFamily: 'CustomFont',
    decoration: TextDecoration.none,
    decorationColor: Color(0x00000000),
  );

  static const _hiddenRoutes = <String>{GameRoute.name, StatisticsRoute.name};

  static const _minimalProfileRoutes = <String>{
    CharacterCreationRoute.name,
    WaitingRoomRoute.name,
  };

  @override
  void initState() {
    super.initState();
    _appRouter = GetIt.I<AppRouter>();
    _menuViewModel = GetIt.I<MainMenuViewModel>();
    _authRepository = GetIt.I<AuthRepository>();
    _appNavigator = GetIt.I<AppNavigator>();
    _shellBack = GetIt.I<ShellChromeBackHandler>();
    _refreshScopedShopBalanceIfReady();
    _authSubscription = _authRepository.authStateChanges.listen((userOption) {
      final accountKey = userOption.fold<String?>(() => null, (u) {
        final f = u.firebaseUid?.trim();
        if (f != null && f.isNotEmpty) return f;
        final id = u.uid.trim();
        if (id.isNotEmpty) return id;
        return null;
      });
      final accountChanged = accountKey != _lastAuthAccountKey;
      if (accountChanged) {
        _lastAuthAccountKey = accountKey;
        _refreshScopedShopBalanceIfReady();
      }
      final avatarId = userOption.match(() => '', (u) => u.avatarId);
      final avatarUrl = userOption.match(() => null, (u) => u.avatarUrl);
      if (!mounted) return;
      if (!accountChanged &&
          avatarId == _currentAvatarId &&
          avatarUrl == _currentAvatarUrl) {
        return;
      }
      setState(() {
        _currentAvatarId = avatarId;
        _currentAvatarUrl = avatarUrl;
      });
    });
    unawaited(_loadInitialAvatar());
    _appRouter.addListener(_onAppRouterChanged);
    _syncShellListener();
  }

  void _refreshScopedShopBalanceIfReady() {
    final scope = GetIt.I<SessionScopeManager>().currentScope;
    if (scope == null || !scope.isRegistered<ShopRepository>()) return;
    scope.get<ShopRepository>().refreshBalance();
  }

  @override
  void dispose() {
    unawaited(_authSubscription?.cancel());
    _shellListenerTarget?.removeListener(_onInnerStackChanged);
    _appRouter.removeListener(_onAppRouterChanged);
    super.dispose();
  }

  Future<void> _loadInitialAvatar() async {
    final result = await _authRepository.getCurrentUser().run();
    result.match((_) {}, (userOption) {
      final avatarId = userOption.match(() => '', (u) => u.avatarId);
      final avatarUrl = userOption.match(() => null, (u) => u.avatarUrl);
      if (!mounted ||
          (avatarId == _currentAvatarId && avatarUrl == _currentAvatarUrl)) {
        return;
      }
      setState(() {
        _currentAvatarId = avatarId;
        _currentAvatarUrl = avatarUrl;
      });
    });
  }

  void _syncShellListener() {
    final shell = _appRouter.innerRouterOf<StackRouter>(
      AuthenticatedShellRoute.name,
    );
    if (identical(shell, _shellListenerTarget)) return;
    _shellListenerTarget?.removeListener(_onInnerStackChanged);
    _shellListenerTarget = shell;
    _shellListenerTarget?.addListener(_onInnerStackChanged);
  }

  void _onAppRouterChanged() {
    _syncShellListener();
    _onNavigationChanged();
  }

  void _onInnerStackChanged() {
    _onNavigationChanged();
  }

  void _onNavigationChanged() {
    if (!mounted) return;
    setState(() {
      if (_shouldHide) _open = false;
      final name = _shellRouter?.current.name;
      if (_minimalChrome(name)) _open = false;
    });
  }

  bool get _shouldHide {
    final shell = _appRouter.innerRouterOf<StackRouter>(
      AuthenticatedShellRoute.name,
    );
    if (shell == null) return true;
    return _hiddenRoutes.contains(shell.current.name);
  }

  StackRouter? get _shellRouter =>
      _appRouter.innerRouterOf<StackRouter>(AuthenticatedShellRoute.name);

  String _chromeTitle(
    StackRouter? shell,
    String? routeName,
    CoreLocalizations l10n,
    BuildContext context,
  ) {
    if (routeName == MainMenuRoute.name) {
      return '';
    }
    if (shell != null &&
        !shell.canPop() &&
        (routeName == null || routeName.isEmpty)) {
      return '';
    }
    if (shell != null && !shell.canPop()) {
      final atRoot = _titleForRoute(routeName, context);
      if (atRoot != null && atRoot.isNotEmpty) return atRoot;
      return '';
    }
    return _titleForRoute(routeName, context) ?? l10n.appTitle;
  }

  String? _titleForRoute(String? routeName, BuildContext context) {
    if (routeName == null) return null;
    final core = CoreLocalizations.of(context);
    if (core == null) return null;
    switch (routeName) {
      case MainMenuRoute.name:
        return '';
      case JoinGameSessionRoute.name:
        return JoinGameSessionLocalizations.of(context)?.joinGameTitle;
      case SelectGameSessionRoute.name:
        return SelectGameSessionLocalizations.of(context)?.createGame;
      case CharacterCreationRoute.name:
        return CharacterCreationLocalizations.of(context)?.createPlayerTitle;
      case WaitingRoomRoute.name:
        return WaitingRoomLocalizations.of(context)?.waitingRoomTitle;
      case FriendsRoute.name:
        return core.friends;
      case ShopRoute.name:
        return core.shop;
      case ProfileRoute.name:
        return ProfileLocalizations.of(context)?.profileTitle;
      case GameHistoryRoute.name:
        return core.gameHistory;
      case LogsHistoryRoute.name:
        return core.connectionHistory;
      case LoadingRoute.name:
        return core.loading;
      default:
        return core.appTitle;
    }
  }

  String _chromeBackLabel(
    BuildContext context,
    String? routeName,
    CoreLocalizations core,
  ) {
    switch (routeName) {
      case CharacterCreationRoute.name:
        return CharacterCreationLocalizations.of(context)?.backToCreateGame ??
            core.homePage;
      case WaitingRoomRoute.name:
        return WaitingRoomLocalizations.of(context)?.back ?? core.homePage;
      default:
        return core.homePage;
    }
  }

  bool _minimalChrome(String? routeName) =>
      routeName != null && _minimalProfileRoutes.contains(routeName);

  bool _showHomeLink(String? routeName, StackRouter? shell) {
    if (shell == null) return false;
    if (routeName == MainMenuRoute.name) return false;
    if (!shell.canPop() && (routeName == null || routeName.isEmpty)) {
      return false;
    }
    return true;
  }

  void _onChromeBack(String? routeName, StackRouter? shell) {
    if (shell == null) return;
    if (!_showHomeLink(routeName, shell)) return;
    _open = false;
    _shellBack.invokeCustomOrGoHome(shell);
  }

  @override
  Widget build(BuildContext context) {
    if (_shouldHide) return const SizedBox.shrink();

    final l10n = CoreLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    final shell = _shellRouter;
    final routeName = shell?.current.name;
    final title = _chromeTitle(shell, routeName, l10n, context);
    final showHome = _showHomeLink(routeName, shell);
    final backLabel = _chromeBackLabel(context, routeName, l10n);
    final minimalChrome = _minimalChrome(routeName);
    final menuTop = shellChromeBodyTopInset(context) - 4;
    const titleShadows = [
      Shadow(color: Color(0x99000000), offset: Offset(0, 2), blurRadius: 8),
    ];
    const titleStyle = TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontFamily: 'CustomFont',
      fontWeight: FontWeight.bold,
      shadows: titleShadows,
      decoration: TextDecoration.none,
      decorationColor: Color(0x00000000),
    );
    const homeLinkStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'CustomFont',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      shadows: titleShadows,
      decoration: TextDecoration.none,
      decorationColor: Color(0x00000000),
    );

    return Watch((context) {
      final avatarPath = AuthAvatarAssets.assetPathForAvatarId(
        _currentAvatarId,
      );
      final avatarUrl = (_currentAvatarUrl?.trim().isNotEmpty ?? false)
          ? EnvConfig.resolveAvatarUrl(_currentAvatarUrl!)
          : null;
      final shopRepo = scopedShopRepositoryOrNull(GetIt.I);
      final balance = switch (shopRepo?.state.value) {
        ShopStateLoaded(:final balance) => balance,
        ShopStateLoading() => 0,
        null => 0,
      };

      return Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 6, 8, 8),
                child: Material(
                  type: MaterialType.transparency,
                  child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const SizedBox(width: double.infinity, height: 50),
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: titleStyle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: showHome
                            ? Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () => setState(
                                    () => _onChromeBack(routeName, shell),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 6,
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.chevron_left,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            backLabel,
                                            maxLines: 1,
                                            style: homeLinkStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                    if (!minimalChrome)
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('$balance', style: _balanceTextStyle),
                              const SizedBox(width: 6),
                              Image.asset(
                                UiAssets.goldCoin,
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 8),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => setState(() => _open = !_open),
                                  customBorder: const CircleBorder(),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            context.interactionColors.outline,
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: avatarUrl == null
                                          ? Image.asset(
                                              avatarPath,
                                              width: 46,
                                              height: 46,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              avatarUrl,
                                              width: 46,
                                              height: 46,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, _, _) =>
                                                  Image.asset(
                                                    avatarPath,
                                                    width: 46,
                                                    height: 46,
                                                    fit: BoxFit.cover,
                                                  ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                ),
              ),
            ),
          ),
          if (_open && !minimalChrome)
            Positioned(
              top: menuTop,
              right: 12,
              child: TapRegion(
                onTapOutside: (_) => setState(() => _open = false),
                child: Material(
                  color: Colors.transparent,
                  elevation: 15,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 220,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: context.interactionColors.outline,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _option(context, l10n.profile, () {
                          setState(() => _open = false);
                          _menuViewModel.openProfile();
                        }),
                        const Divider(height: 1),
                        _option(context, l10n.connectionHistory, () {
                          setState(() => _open = false);
                          _menuViewModel.openConnectionHistory();
                        }),
                        const Divider(height: 1),
                        _option(context, l10n.gameHistory, () {
                          setState(() => _open = false);
                          _menuViewModel.openGameHistory();
                        }),
                        const Divider(height: 1),
                        _option(context, l10n.signOut, () {
                          setState(() => _open = false);
                          unawaited(_menuViewModel.signOut());
                          _appNavigator.request(GoToAuth());
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _option(BuildContext context, String label, VoidCallback onTap) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      splashColor: scheme.primary.withValues(alpha: 0.25),
      highlightColor: scheme.primary.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: scheme.onSurface,
              fontFamily: 'CustomFont',
              decoration: TextDecoration.none,
              decorationColor: const Color(0x00000000),
            ),
          ),
        ),
      ),
    );
  }
}

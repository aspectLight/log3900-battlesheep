import 'dart:async';

import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/chat/chat_avatar_registry.dart';
import '../../../../core/chat/chat_outgoing_avatars.dart';
import '../../../../core/connected_scope/connected_session.dart';
import '../../../../core/connected_scope/session_scope_manager.dart';
import '../../../../core/app_transition/feature_coordinator.dart';
import '../../../../routing/app_navigator.dart';
import '../../../../routing/navigation_command.dart';
import '../app_events/auth_events.dart';
import '../context/auth_data.dart';
import '../interfaces/auth_repository.dart';
import '../../domain/commands/auth_commands.dart' as auth_commands;
import '../di/auth_module.dart';
import '../../../shop/data/repositories/shop_repository.dart';

class AuthenticationCoordinator
    implements
        FeatureCoordinator<
          AuthEntryAppEvent,
          AuthCompletedAppEvent,
          AuthExitAppEvent
        > {
  AuthenticationCoordinator({
    required this.getIt,
    required this.sessionScopeManager,
    required this.appNavigator,
    required this.authRepository,
    required this.appTransitionEventBus,
  });

  final GetIt getIt;
  final SessionScopeManager sessionScopeManager;
  final AppNavigator appNavigator;
  final AuthRepository authRepository;
  final AppTransitionEventBus appTransitionEventBus;

  late AuthData _authData;

  @override
  Future<void> onEntry(AuthEntryAppEvent event) async {
    switch (event) {
      case SignInSuccessEvent(:final user):
        getIt<ChatOutgoingAvatars>().setFromAvatarFields(
          avatarId: user.avatarId,
          avatarRelativeUrl: user.avatarUrl,
        );
        getIt<ChatAvatarRegistry>().setLocal(
          user.username,
          avatarId: user.avatarId,
          avatarRelativeUrl: user.avatarUrl,
        );
        _authData = AuthData(username: user.username, socketId: '');
        appNavigator.request(GoToMainMenu());
        // Always tear down any previous session scope so a new login never reuses
        // another user's GetIt registrations (e.g. ShopRepository balance cache).
        await sessionScopeManager.dropScope();
        sessionScopeManager.createScope();
        final scope = sessionScopeManager.currentScope;
        if (scope == null) return;
        registerConnectedScope(scope, getIt);
        sessionScopeManager.setSession(
          ConnectedSession(
            username: _authData.username,
            socketId: _authData.socketId,
          ),
        );
      case SessionConnectedEvent(:final socketId):
        _authData = _authData.copyWith(socketId: socketId);
        sessionScopeManager.setSession(
          ConnectedSession(
            username: _authData.username,
            socketId: _authData.socketId,
          ),
        );
        appTransitionEventBus.fire(
          AuthCompletedAppEvent(username: _authData.username),
        );
    }
  }

  @override
  Future<void> onCompleted(AuthCompletedAppEvent event) async {
    final scope = sessionScopeManager.currentScope;
    if (scope == null) return;
    bootstrapConnectedScope(scope);
  }

  @override
  Future<void> onExit(AuthExitAppEvent event) async {
    await authRepository.signOut(const auth_commands.SignOutCommand()).run();
    getIt<ChatOutgoingAvatars>().clear();
    getIt<ChatAvatarRegistry>().clear();
    final scope = sessionScopeManager.currentScope;
    if (scope != null && scope.isRegistered<ShopRepository>()) {
      scope.get<ShopRepository>().resetToInitial();
    }
    await sessionScopeManager.dropScope();
    // Only Auth drops root scope; feature scopes are dropped by their coordinators
    appNavigator.request(ForceUnauthenticated());
  }
}

import 'dart:async';

import 'package:fpdart/fpdart.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/connected_scope/session_scope_manager.dart';
import '../../../../core/helpers/functional_programming.dart';
import '../../../../core/services/log_service.dart';
import '../../../../core/services/socket_service.dart';
import '../../../select_game_session/data/repositories/select_game_session_currency_repository.dart';
import '../../../shop/data/repositories/shop_repository.dart';
import '../../core/app_events/auth_events.dart';
import '../../core/interfaces/auth_repository.dart';
import '../../domain/models/user.dart';

/// Long-lived side effect that keeps the socket connection in sync with auth state
/// and drives app transitions when the session is established.
///
/// **Responsibilities:**
/// - Listens to [AuthRepository.authStateChanges] and [SocketService.connectionStream].
/// - When a user is signed in and has socket credentials: connects the socket (or on startup
///   restores connection if already signed in).
/// - When the user signs out: disconnects the socket.
/// - When the socket connects: fires [AuthEntryAppEvent.sessionConnected] with the transport id
///   so the top-level coordinator can transition to the connected session (auth + chat, etc.).
///
class SocketConnectionSideEffect {
  final AuthRepository _authRepository;
  final SocketService _socketService;
  final AppTransitionEventBus _appTransitionEventBus;
  final SessionScopeManager _sessionScopeManager;
  final SelectGameSessionCurrencyRepository _currencyRepository;
  StreamSubscription<Option<UserModel>>? _authSubscription;
  StreamSubscription<bool>? _connectionSubscription;
  bool _isConnecting = false;
  /// Last account identity we cleared cached money UI for (avoids flicker on duplicate emits).
  String? _lastAccountKey;

  SocketConnectionSideEffect({
    required AuthRepository authRepository,
    required SocketService socketService,
    required AppTransitionEventBus appTransitionEventBus,
    required SessionScopeManager sessionScopeManager,
    required SelectGameSessionCurrencyRepository currencyRepository,
  }) : _authRepository = authRepository,
       _socketService = socketService,
       _appTransitionEventBus = appTransitionEventBus,
       _sessionScopeManager = sessionScopeManager,
       _currencyRepository = currencyRepository {
    _authSubscription = _authRepository.authStateChanges.listen(_onUserChanged);
    _connectionSubscription = _socketService.connectionStream.listen(
      _onConnectionChanged,
    );
    unawaited(_checkInitialState());
  }

  Future<void> _checkInitialState() async {
    final currentUserResult = await _authRepository.getCurrentUser().run();
    switch (currentUserResult) {
      case Left():
        break;
      case Right(value: final userOption):
        userOption.whenPresent((_) => _connectIfNeeded());
    }
  }

  void _connectIfNeeded() {
    if (_socketService.isConnected || _isConnecting) return;
    _authRepository.getSocketAuthCredentials().whenPresent((creds) {
      _isConnecting = true;
      unawaited(
        _socketService
            .connect(token: creds.token, sessionId: creds.sessionId)
            .run()
            .then((result) {
              result.fold(
                (e) => LogService.e('Socket connection failed', e),
                (_) => {},
              );
            })
            .whenComplete(() => _isConnecting = false),
      );
    });
  }

  void _onUserChanged(Option<UserModel> userOption) {
    userOption.fold(
      () {
        _lastAccountKey = null;
        _currencyRepository.resetBalance();
        _resetShopIfScoped();
        if (_socketService.isConnected) _socketService.disconnect();
      },
      (user) {
        final key = _accountKey(user);
        if (key != null && key != _lastAccountKey) {
          _lastAccountKey = key;
          _currencyRepository.resetBalance();
          _resetShopIfScoped();
        }
        _connectIfNeeded();
      },
    );
  }

  static String? _accountKey(UserModel user) {
    final f = user.firebaseUid?.trim();
    if (f != null && f.isNotEmpty) return f;
    final id = user.uid.trim();
    if (id.isNotEmpty) return id;
    return null;
  }

  void _resetShopIfScoped() {
    final scope = _sessionScopeManager.currentScope;
    if (scope != null && scope.isRegistered<ShopRepository>()) {
      scope.get<ShopRepository>().resetToInitial();
    }
  }

  void _onConnectionChanged(bool connected) {
    if (connected) {
      _socketService.socketIdOption.whenPresent((socketId) {
        _appTransitionEventBus.fire(
          AuthEntryAppEvent.sessionConnected(socketId),
        );
      });
      return;
    }
    _connectIfNeeded();
  }

  void dispose() {
    unawaited(_authSubscription?.cancel());
    unawaited(_connectionSubscription?.cancel());
  }
}

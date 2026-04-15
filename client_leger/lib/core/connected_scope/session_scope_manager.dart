import 'dart:async';

import 'package:get_it/get_it.dart';

import 'connected_session.dart';

/// Manages the root session scope and session metadata
///
/// # Overview
/// This is the central manager for the user's authenticated session. It:
/// - Creates and drops the ROOT scope (not feature scopes)
/// - Stores the current session info (who is logged in)
/// - Provides access to the scope for all features
///
/// # Architecture Role
/// ```text
/// App Start
///   ↓
/// User Signs In → SessionScopeManager.createScope()
///   ↓
/// Root session scope exists
/// ```
class SessionScopeManager {
  SessionScopeManager(this._getIt);

  final GetIt _getIt;
  GetIt? _scope;
  ConnectedSession? _currentSession;

  GetIt? get currentScope => _scope;
  ConnectedSession? get currentSession => _currentSession;

  void createScope() {
    if (_scope != null) return;
    _getIt.pushNewScope(
      scopeName: 'session',
      init: (scope) {
        _scope = scope;
      },
    );
  }

  void setSession(ConnectedSession session) {
    _currentSession = session;
  }

  void dropScope() {
    if (_scope == null) return;
    unawaited(_getIt.dropScope('session'));
    _scope = null;
    _currentSession = null;
  }
}

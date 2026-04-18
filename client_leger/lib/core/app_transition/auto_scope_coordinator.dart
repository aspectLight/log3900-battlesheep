import 'dart:async';

import 'package:get_it/get_it.dart';

import '../connected_scope/session_scope_manager.dart';
import 'app_transition_bus.dart';
import 'feature_coordinator.dart';

/// Base class for feature coordinators that automatically manage scope
///
/// # The Problem This Solves
/// Coordinators used to:
/// 1. Store nullable state fields (`String? _roomId`, `GetIt? _scope`)
/// 2. Manually push scopes in onEntry
/// 3. Manually drop scopes in onExit
/// 4. Hope developers remembered to set all fields
/// 5. Hope developers pushed/dropped scopes at the right time
///
/// This led to bugs where:
/// - Developers forgot to set a field → runtime crash
/// - Developers forgot to push scope → runtime crash
/// - Developers pushed scope twice → scope leak
/// - Developers dropped scope at wrong time → dangling references
///
/// # The Solution
/// This base class:
/// - Manages scope automatically (you can't forget)
/// - Uses type-safe data classes (compiler prevents null bugs)
/// - Enforces a clear lifecycle: Entry → Completed → Exit
///
/// # How It Works
/// 1. You create a Data class (e.g., GameSessionData)
/// 2. You extend `AutoScopeCoordinator<Data, Entry, Completed, Exit>`
/// 3. You implement onEntryImpl (return data, scope created automatically)
/// 4. You implement onCompletedImpl (scope guaranteed to exist)
/// 5. You implement onExitImpl (cleanup, scope dropped automatically)
///
/// # The Lifecycle
/// ```text
/// onEntry called
///   ↓
/// Your onEntryImpl runs → returns Data
///   ↓
/// Framework pushes scope automatically
///   ↓
/// onCompleted called
///   ↓
/// Your onCompletedImpl runs with guaranteed Data + scope
///   ↓
/// onExit called
///   ↓
/// Your onExitImpl runs with guaranteed Data + scope
///   ↓
/// Framework drops scope automatically
/// ```
///
/// # What This Prevents
/// - Null data in later phases (compiler proves data exists)
/// - Forgetting to push scope (framework does it)
/// - Dropping scope at wrong time (framework handles order)
/// - Duplicating scope logic (one base class, not in every coordinator)
///
/// # When to Use
/// Use this for Feature Scopes:
/// - GameSessionCoordinator
/// - ChatCoordinator
/// - StatisticsCoordinator
/// - Any new feature that creates a nested scope under session
///
/// Do NOT use for:
/// - AuthenticationCoordinator (creates root session scope, not nested)
/// - Any coordinator that doesn't follow Entry→Completed→Exit
///
/// # Key Insight
/// This base class makes impossible states impossible. You can't have a phase
/// without the data it needs, and you can't forget scope management.
abstract class AutoScopeCoordinator<
  Data,
  Entry extends AppTransitionEvent,
  Completed extends AppTransitionEvent,
  Exit extends AppTransitionEvent
>
    implements FeatureCoordinator<Entry, Completed, Exit> {
  /// The name of the scope this feature creates (e.g., 'game', 'chat', 'statistics')
  ///
  /// Used by the session scope manager to identify and drop scopes.
  /// Must be unique within your app.
  String get scopeName;

  /// Get the session scope manager
  ///
  /// Subclasses implement this to return their injected SessionScopeManager.
  /// The framework uses this to push/drop scopes.
  SessionScopeManager get sessionScopeManager;

  /// Called when scope is created (optional override)
  ///
  /// This is the perfect time to:
  /// - Register services in the scope
  /// - Set up scope-specific state
  /// - Call scope holder methods (e.g., gameScopeHolder.setScope)
  ///
  /// This is preferred over onCompletedImpl for service registration because
  /// it keeps onCompleted focused on bootstrapping, not setup.
  void onScopeCreated(GetIt scope) {}

  /// Called when scope is dropped (optional override)
  ///
  /// This is the perfect time to:
  /// - Clean up scope-specific state
  /// - Log scope teardown
  /// - Call scope holder clear methods
  void onScopeDropped() {}

  GetIt? _featureScope;
  late Data _entryData;
  bool _isExiting = false;

  /// The data collected during Entry phase
  ///
  /// Access this in onScopeCreated or onCompletedImpl to use entry data.
  /// Guaranteed to exist when needed.
  Data get entryData => _entryData;

  /// The scope created by the framework
  ///
  /// Access this in onScopeCreated, onCompletedImpl, or onExitImpl.
  /// Guaranteed to exist after onScopeCreated is called.
  GetIt? get featureScope => _featureScope;

  /// YOUR IMPLEMENTATION: What to do during Entry phase
  ///
  /// # Contract
  /// - You MUST collect all data needed for Completed phase
  /// - Return non-null data when you want to proceed
  /// - Return null to skip scope creation (edge case)
  ///
  /// # Important
  /// DO NOT create scope here. The framework does that after this returns.
  /// If you return data, scope is created automatically.
  Future<Data?> onEntryImpl(Entry event);

  /// YOUR IMPLEMENTATION: What to do during Completed phase
  ///
  /// # Contract
  /// - You receive the Data returned from onEntryImpl (guaranteed non-null)
  /// - Scope is guaranteed to exist (access via `featureScope`)
  /// - Bootstrap the scope with any additional setup
  Future<void> onCompletedImpl(Completed event, Data data);

  /// YOUR IMPLEMENTATION: What to do during Exit phase
  ///
  /// # Contract
  /// - You receive the original Data (guaranteed non-null)
  /// - Scope is guaranteed to exist (access via `featureScope`)
  /// - Clean up anything that was set up
  ///
  /// # Important
  /// DO NOT drop scope here. The framework does that after this returns.
  Future<void> onExitImpl(Exit event, Data data);

  bool get tearDownStaleFeatureScopeOnEntry => false;

  /// Call when this feature's scope was dropped outside [onExit], for example
  /// after a failed [onCompletedImpl] bootstrap, so the next [onEntry] is not blocked.
  void markFeatureScopeReleased() {
    _featureScope = null;
  }

  @override
  Future<void> onEntry(Entry event) async {
    final data = await onEntryImpl(event);
    if (data == null) return;
    _entryData = data;
    final sessionScope = sessionScopeManager.currentScope;
    if (sessionScope == null) return;
    if (_featureScope != null) {
      if (!tearDownStaleFeatureScopeOnEntry) return;
      await sessionScope.dropScope(scopeName);
      _featureScope = null;
      onScopeDropped();
    }
    sessionScope.pushNewScope(
      scopeName: scopeName,
      init: (GetIt scope) {
        _featureScope = scope;
        onScopeCreated(scope);
      },
    );
  }

  @override
  Future<void> onCompleted(Completed event) async {
    final scope = _featureScope;
    if (scope == null) return;
    await onCompletedImpl(event, _entryData);
  }

  @override
  Future<void> onExit(Exit event) async {
    if (_isExiting) return;
    final scope = _featureScope;
    if (scope == null) return;
    _isExiting = true;
    try {
      await onExitImpl(event, _entryData);
      final sessionScope = sessionScopeManager.currentScope;
      if (sessionScope != null) {
        await sessionScope.dropScope(scopeName);
      }
      _featureScope = null;
      onScopeDropped();
    } finally {
      _isExiting = false;
    }
  }
}

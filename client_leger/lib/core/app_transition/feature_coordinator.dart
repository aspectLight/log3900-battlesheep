import 'app_transition_bus.dart';

/// Contract for all feature coordinators
///
/// # Purpose
/// This interface defines the lifecycle that ALL coordinators must follow:
/// Entry → Completed → Exit
///
/// # When to Implement
/// Implement this interface when creating a feature coordinator:
/// - GameSessionCoordinator
/// - ChatCoordinator
/// - AuthenticationCoordinator
/// - StatisticsCoordinator
/// - Any new feature
///
/// # The Three Phases
/// 1. **onEntry()**: Initialize feature, create scope, collect data
/// 2. **onCompleted()**: Scope ready, bootstrap and setup
/// 3. **onExit()**: Clean up, drop scope, navigate away
///
/// # How It Connects
/// - Events are fired: EntryEvent → CompletedEvent → ExitEvent
/// - AppEventHandler routes events to handlers
/// - Handlers call onEntry(), onCompleted(), onExit()
/// - Coordinators implement these methods to define feature behavior
///
/// # Design Note
/// This is intentionally generic. The actual Entry/Completed/Exit event types
/// are generic parameters, so each feature can define its own event types.
///
/// # Lifecycle Guarantee
/// The AppEventHandler ensures onEntry runs before onCompleted, and
/// onCompleted before onExit. You can rely on this ordering.
abstract interface class FeatureCoordinator<
  Entry extends AppTransitionEvent,
  Completed extends AppTransitionEvent,
  Exit extends AppTransitionEvent
> {
  /// Phase 1: Feature is entering
  ///
  /// # Responsibilities
  /// - Extract data from the event
  /// - Create or initialize scope
  /// - Register services (optional, can defer to Completed)
  /// - Store state needed for later phases
  /// - Optionally fire Completed event (to trigger next phase)
  ///
  /// # Do NOT Do
  /// - Don't bootstrap yet (wait for Completed)
  /// - Don't assume scope exists (create it first)
  /// - Don't do heavy async work that should be in Completed
  ///
  /// # When This Runs
  /// When the corresponding EntryEvent is fired on the event bus.
  Future<void> onEntry(Entry event);

  /// Phase 2: Feature initialization is complete
  ///
  /// # Responsibilities
  /// - Scope is guaranteed to exist now
  /// - Bootstrap the scope with remaining setup
  /// - Final preparation for the feature
  /// - Get feature ready for user interaction
  ///
  /// # Do NOT Do
  /// - Don't create scope (Entry already did)
  /// - Don't collect data (Entry already did)
  ///
  /// # When This Runs
  /// When the corresponding CompletedEvent is fired on the event bus.
  /// This usually happens automatically from onEntry, but can be manual.
  Future<void> onCompleted(Completed event);

  /// Phase 3: Feature is exiting
  ///
  /// # Responsibilities
  /// - Clean up the feature
  /// - Save state if needed
  /// - Drop the scope
  /// - Navigate away
  ///
  /// # Do NOT Do
  /// - Don't assume data exists (it was in earlier phases)
  /// - Don't create new state here (cleanup only)
  ///
  /// # When This Runs
  /// When the corresponding ExitEvent is fired on the event bus.
  /// This happens when user navigates away or app closes.
  Future<void> onExit(Exit event);
}

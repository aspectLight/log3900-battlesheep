import 'app_transition_bus.dart' show AppTransitionEvent;

/// Handles a specific type of transition event
///
/// # Purpose
/// This is the contract between the event bus and feature coordinators.
/// Each handler knows how to respond to one (or more) types of events.
///
/// # Key Responsibility
/// - Implement `canHandle()` to decide if this handler should process an event
/// - Implement `handle()` to process the event (usually by calling coordinator)
///
/// # Design Pattern
/// This uses the Strategy pattern. Each delegate is a different strategy for
/// handling events. The AppEventHandler collects all strategies and dispatches
/// to the right one.
///
/// # Important
/// Do NOT inherit from this directly. Instead, use GenericHandlerDelegate
/// which implements this interface for all your features automatically.
///
/// # Why This Exists
/// Before: Each feature had 3 custom handler classes (Entry, Completed, Exit).
/// Now: One GenericHandlerDelegate handles all features.
/// This eliminates boilerplate and makes changes centralized.
abstract interface class AppEventHandlerDelegate<T extends AppTransitionEvent> {
  /// The event type this handler is responsible for
  ///
  /// Used for debugging and type checking.
  /// Example: GameSessionEntryAppEvent
  Type get eventType;

  /// Can this handler process the given event?
  ///
  /// # Why This Exists
  /// The event bus doesn't know event types at compile time. Multiple handlers
  /// might listen to the same event bus, so each must declare what it handles.
  ///
  /// # Implementation Note
  /// This is a guard clause that prevents unnecessary processing.
  /// Implement as: `event is YourEventType`
  bool canHandle(AppTransitionEvent event);

  /// Process the event
  ///
  /// This runs asynchronously and is fire-and-forget. The AppEventHandler
  /// won't wait for this to complete - it just schedules it.
  ///
  /// # Common Implementation
  /// Cast event to your type, then delegate to coordinator:
  /// ```dart
  /// final e = event as YourEventType;
  /// await coordinator.onEntry(e);
  /// ```
  ///
  /// But with GenericHandlerDelegate, you pass this logic as a callback.
  Future<void> handle(AppTransitionEvent event);
}

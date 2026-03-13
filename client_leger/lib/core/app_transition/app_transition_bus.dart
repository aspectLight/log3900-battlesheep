import 'package:event_bus/event_bus.dart';

/// Event bus for coordinating app-wide state transitions
///
/// # Overview
/// The AppTransitionEventBus is the central communication hub for all feature
/// lifecycle events (entry, completion, exit). It decouples feature coordinators
/// from each other by using an event-driven architecture.
///
/// # When to Use
/// Fire an event when a feature changes lifecycle state:
/// - When a feature finishes initializing (fire CompletedEvent)
/// - When a user requests to exit a feature (fire ExitEvent)
/// - When system state changes affect features (fire custom events)
///
/// # Architecture Pattern
/// This implements the Observer pattern. Features don't call each other directly;
/// they publish events to the bus, and handlers react to those events.
///
/// # Example
/// ```dart
/// // In a coordinator, when initialization is complete:
/// appTransitionEventBus.fire(GameSessionCompletedAppEvent());
/// ```
///
/// # Key Insight
/// The bus itself doesn't know about specific features. It just routes
/// AppTransitionEvent instances to all registered handlers. This keeps
/// features decoupled and makes the system scalable.
abstract class AppTransitionEvent {
  const AppTransitionEvent();
}

/// Wraps an [AppTransitionEvent] for internal routing on the event bus.
class AppTransitionRequest {
  final AppTransitionEvent event;
  const AppTransitionRequest(this.event);
}

/// Routes lifecycle events to all registered handlers
///
/// # Responsibility
/// - Wraps EventBus to provide type-safe event firing
/// - Converts AppTransitionEvent → AppTransitionRequest for internal routing
/// - Provides stream access for listeners
///
/// # Do NOT Use For
/// - Direct communication between features (use events instead)
/// - Synchronous state changes (use BLoC or state management)
/// - UI state (use other state solutions like Signals, Provider, etc)
class AppTransitionEventBus {
  AppTransitionEventBus(EventBus bus) : _bus = bus;

  final EventBus _bus;

  /// Fire an event to notify all registered handlers
  ///
  /// This is fire-and-forget. Handlers are invoked asynchronously.
  /// If you need a response, use a follow-up event to signal completion.
  void fire(AppTransitionEvent event) {
    _bus.fire(AppTransitionRequest(event));
  }

  /// Subscribe to transition events
  ///
  /// Used internally by AppEventHandler to listen for all events.
  /// You typically don't use this directly - the handler system does.
  Stream<AppTransitionRequest> onTransitionRequested() =>
      _bus.on<AppTransitionRequest>();
}

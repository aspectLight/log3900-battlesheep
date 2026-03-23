import 'app_event_handler_delegate.dart';
import 'app_transition_bus.dart';

typedef EventPredicate = bool Function(AppTransitionEvent);
typedef EventHandler = Future<void> Function(AppTransitionEvent);

/// Generic handler that works for ALL features
///
/// # The Problem This Solves
/// Before: Each feature had 3+ custom handler classes:
/// - GameSessionEntryHandlerDelegate
/// - GameSessionCompletedHandlerDelegate
/// - GameSessionExitHandlerDelegate
/// - ChatEntryHandlerDelegate
/// - ChatExitHandlerDelegate
/// - ... (12+ files total)
///
/// This was pure boilerplate - all doing the exact same thing.
///
/// # The Solution
/// This one class replaces all 12. It's generic enough to handle any event type.
///
/// # How It Works
/// Instead of subclassing for each event type, you instantiate GenericHandlerDelegate
/// with callbacks:
///
/// ```dart
/// GenericHandlerDelegate<GameSessionEntryAppEvent>(
///   eventType: GameSessionEntryAppEvent,
///   canHandleFn: (e) => e is GameSessionEntryAppEvent,
///   handleFn: coordinator.onEntry,
/// )
/// ```
///
/// Now you have a handler that:
/// - Accepts GameSessionEntryAppEvent
/// - Checks if event is the right type
/// - Calls coordinator.onEntry when invoked
///
/// # Why This Matters
/// - Eliminates 60+ lines of boilerplate
/// - Single source of truth for handler logic
/// - Easy to change handler behavior (edit one place, affects all features)
/// - Scales to 50+ features without adding files
///
/// # When to Use
/// Use this for ALL event handlers. It's the only handler delegate you need.
///
/// # Registration Example
/// ```dart
/// // In your DI setup, pass delegates to AppEventHandler:
/// AppEventHandler(
///   appTransitionEventBus: appTransitionEventBus,
///   delegates: [
///     GenericHandlerDelegate<GameSessionEntryAppEvent>(
///       eventType: GameSessionEntryAppEvent,
///       canHandleFn: (e) => e is GameSessionEntryAppEvent,
///       handleFn: coordinator.onEntry,
///     ),
///   ],
/// );
/// ```
class GenericHandlerDelegate<T extends AppTransitionEvent>
    implements AppEventHandlerDelegate<T> {
  GenericHandlerDelegate({
    required this.eventType,
    required this.canHandleFn,
    required this.handleFn,
  });

  factory GenericHandlerDelegate.simple(
    Type eventType,
    Future<Object?> Function(T) handler,
  ) =>
      GenericHandlerDelegate<T>(
        eventType: eventType,
        canHandleFn: (e) => e is T,
        handleFn: (e) async {
          await handler(e as T);
        },
      );

  @override
  final Type eventType;
  final EventPredicate canHandleFn;
  final EventHandler handleFn;

  @override
  bool canHandle(AppTransitionEvent event) => canHandleFn(event);

  @override
  Future<void> handle(AppTransitionEvent event) => handleFn(event);
}

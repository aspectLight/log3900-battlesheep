import 'dart:async';

import 'app_event_handler_delegate.dart';
import 'app_transition_bus.dart';

/// Dispatches events to all registered handlers
///
/// # Responsibility
/// When an event is fired on the bus, this finds all handlers that can handle
/// it and invokes them. This is the central dispatcher.
///
/// # Architecture Role
/// This sits between the event bus and individual handlers:
/// ```text
/// Coordinator fires event
///     ↓
/// EventBus receives event
///     ↓
/// AppEventHandler finds matching handlers
///     ↓
/// Handlers process event
/// ```
///
/// # Key Insight
/// This is the "glue" that connects the event bus to your feature coordinators.
/// Without it, the bus wouldn't know what to do with events.
///
/// # When This Runs
/// - Continuously listening to the event bus (since construction)
/// - When an event fires, immediately finds and invokes matching handlers
/// - Handlers run asynchronously (fire-and-forget)
class AppEventHandler {
  AppEventHandler({
    required this.appTransitionEventBus,
    required List<AppEventHandlerDelegate> delegates,
  }) : _delegates = delegates {
    _sub = appTransitionEventBus.onTransitionRequested().listen(_onRequest);
  }

  final AppTransitionEventBus appTransitionEventBus;
  final List<AppEventHandlerDelegate> _delegates;
  late final StreamSubscription<AppTransitionRequest> _sub;

  /// Find and invoke all handlers that can process this event
  ///
  /// # Process
  /// 1. Find all handlers where canHandle(event) == true
  /// 2. Assert at least one handler found (fail-fast in debug)
  /// 3. Invoke each handler asynchronously (fire-and-forget)
  /// 4. Catch errors and assert (debug only, won't crash in release)
  ///
  /// # Why Fire-and-Forget?
  /// Handlers shouldn't block the event dispatcher. They run asynchronously
  /// to keep the system responsive. If a handler needs results, it fires
  /// a follow-up event.
  ///
  /// # Error Handling Strategy
  /// - Uses assert() which is debug-only (stripped in release builds)
  /// - Errors are logged but not rethrown (fire-and-forget)
  /// - This matches your architecture philosophy: explicit in debug, silent in release
  void _onRequest(AppTransitionRequest request) {
    final event = request.event;
    final matching = _delegates
        .cast<AppEventHandlerDelegate<AppTransitionEvent>>()
        .where((d) => d.canHandle(event))
        .toList();

    assert(
      matching.isNotEmpty,
      'No delegate registered for ${event.runtimeType}',
    );

    for (final delegate in matching) {
      unawaited(
        delegate.handle(event).catchError((Object e, StackTrace st) {
          assert(false, 'Handler for ${event.runtimeType} threw: $e\n$st');
        }),
      );
    }
  }

  /// Clean up the event listener
  ///
  /// Call this when your app is shutting down to avoid memory leaks.
  /// Example: in main.dart during app lifecycle teardown.
  void dispose() {
    unawaited(_sub.cancel());
  }
}

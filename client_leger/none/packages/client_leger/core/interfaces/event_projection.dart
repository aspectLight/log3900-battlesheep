import 'dart:async';

/// Contract for event projections that subscribe to streams (e.g. socket, event bus)
/// and push updates into repositories. Implement [subscribe] to return the list of
/// [StreamSubscription]s; the coordinator owns lifecycle and cancels them on dispose.
abstract class EventProjection {
  List<StreamSubscription> subscribe();
}

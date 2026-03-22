import 'dart:async';

class ReplayLatestBroadcastController<T> {
  T? _latestEvent;
  bool _hasLatestEvent = false;

  late final StreamController<T> _controller = StreamController<T>.broadcast(
    onListen: _flushPendingEvent,
  );

  Stream<T> get stream => _controller.stream;

  bool get isClosed => _controller.isClosed;

  void add(T event) {
    if (_controller.isClosed) return;
    _latestEvent = event;
    _hasLatestEvent = true;
    if (_controller.hasListener) _controller.add(event);
  }

  void _flushPendingEvent() {
    if (!_hasLatestEvent || _controller.isClosed) return;
    _controller.add(_latestEvent as T);
  }

  Future<void> close() async {
    _latestEvent = null;
    _hasLatestEvent = false;
    await _controller.close();
  }

  void clearLatest() {
    _latestEvent = null;
    _hasLatestEvent = false;
  }
}

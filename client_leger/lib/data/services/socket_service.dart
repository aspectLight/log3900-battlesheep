import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../core/exceptions/socket_exception.dart';
import '../../domain/interfaces/services/socket_service.dart';
import 'log_service.dart';

class SocketServiceImpl implements SocketService {
  io.Socket? _socket;
  bool _isConnected = false;

  final _connectionSubject = BehaviorSubject<bool>.seeded(false);
  final _errorController = StreamController<dynamic>.broadcast();
  final Map<String, StreamController<dynamic>> _eventControllers = {};

  @override
  bool get isConnected => _isConnected;

  @override
  Stream<bool> get connectionStream => _connectionSubject.stream;

  @override
  Stream<dynamic> get errorStream => _errorController.stream;

  @override
  TaskEither<SocketException, Unit> connect(String url) {
    return TaskEither.tryCatch(
      () async {
        if (_isConnected) {
          disconnect();
        }
        LogService.i('Connecting to socket at $url');
        _socket = io.io(url, <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
        });
        _setupCoreListeners();
        _socket!.connect();
        await _waitForConnection();
        return unit;
      },
      (error, stack) {
        LogService.e('Socket connection failed', error);
        if (error is SocketException) return error;
        return UnknownSocketException(error.toString());
      },
    );
  }

  Future<void> _waitForConnection() async {
    final completer = Completer<void>();
    void onConnect(_) {
      if (!completer.isCompleted) completer.complete();
    }

    void onError(error) {
      if (!completer.isCompleted) {
        completer.completeError(ConnectionFailedException(error.toString()));
      }
    }

    _socket!.once('connect', onConnect);
    _socket!.once('connect_error', onError);
    await completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw const SocketTimeoutException(),
    );
  }

  void _setupCoreListeners() {
    _socket!.on('connect', (_) {
      LogService.i('Socket connected');
      _isConnected = true;
      _connectionSubject.add(true);
    });
    _socket!.on('disconnect', (_) {
      LogService.w('Socket disconnected');
      _isConnected = false;
      _connectionSubject.add(false);
    });
    _socket!.on('error', (error) {
      LogService.e('Socket error', error);
      _errorController.add(error);
    });
  }

  @override
  void disconnect() {
    if (_socket == null) return;
    _socket!.disconnect();
    _socket!.dispose();
    _socket = null;
    _isConnected = false;
    _connectionSubject.add(false);
    LogService.i('Socket disconnected');
  }

  @override
  void emit(String event, [dynamic data]) {
    if (!_isConnected || _socket == null) {
      LogService.w('Cannot emit $event: not connected');
      return;
    }
    _socket!.emit(event, data);
    LogService.d('Emitted event: $event');
  }

  @override
  Stream<dynamic> on(String event) {
    return _eventControllers.putIfAbsent(event, () {
      final controller = StreamController<dynamic>.broadcast();
      _socket?.on(event, controller.add);
      return controller;
    }).stream;
  }

  @override
  void off(String event) {
    _socket?.off(event);
    final controller = _eventControllers.remove(event);
    if (controller != null) unawaited(controller.close());
  }

  @override
  void dispose() {
    disconnect();
    unawaited(_connectionSubject.close());
    unawaited(_errorController.close());
    for (final controller in _eventControllers.values) {
      unawaited(controller.close());
    }
    _eventControllers.clear();
    LogService.i('SocketService disposed');
  }
}

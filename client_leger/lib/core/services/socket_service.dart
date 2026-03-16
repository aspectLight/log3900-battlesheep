import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../constants/socket_constants.dart';
import '../exceptions/socket_exception.dart';
import 'log_service.dart';

class SocketService {
  final String _url;
  io.Socket? _socket;
  bool _isConnected = false;

  final _connectionSubject = BehaviorSubject<bool>.seeded(false);
  final _errorController = StreamController<Object?>.broadcast();
  final Map<String, StreamController<Object?>> _eventControllers = {};

  SocketService({required String url}) : _url = url;

  bool get isConnected => _isConnected;

  Option<String> get socketIdOption => Option.fromNullable(_socket?.id);

  Stream<bool> get connectionStream => _connectionSubject.stream;

  Stream<Object?> get errorStream => _errorController.stream;

  TaskEither<SocketException, Unit> connect({
    required String token,
    required String sessionId,
  }) {
    return TaskEither.tryCatch(
      () async {
        if (_isConnected) {
          disconnect();
        }
        LogService.i('Connecting to socket at $_url');
        _socket = io.io(_url, <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
          'auth': <String, String>{'token': token, 'sessionId': sessionId},
        });
        _setupCoreListeners();
        for (final e in _eventControllers.entries) {
          _socket!.on(e.key, e.value.add);
        }
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
      const Duration(seconds: SocketConstants.connectTimeoutSeconds),
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

  void disconnect() {
    if (_socket == null) return;
    _socket!.disconnect();
    _socket!.dispose();
    _socket = null;
    _isConnected = false;
    _connectionSubject.add(false);
    LogService.i('Socket disconnected');
  }

  void emit<T extends Object?>(String event, [T? data]) {
    _socket!.emit(event, data);
    LogService.d('Emitted event: $event');
  }

  Future<T?> emitWithAck<T extends Object?>(String event, Object? data) {
    final completer = Completer<T?>();
    _socket!.emitWithAck(event, data, ack: (response) {
      if (!completer.isCompleted) completer.complete(response as T?);
    });
    LogService.d('Emitted event with ack: $event');
    return completer.future;
  }

  Future<Either<E, R>> emitWithAckEither<E, R>(
    String event,
    Object? data,
    Either<E, R> Function(Object? raw) parse,
  ) async =>
      parse(await emitWithAck<Object?>(event, data));

  Stream<T> on<T extends Object?>(String event) {
    return _eventControllers
        .putIfAbsent(event, () {
          final controller = StreamController<Object?>.broadcast();
          _socket?.on(event, controller.add);
          return controller;
        })
        .stream
        .where((data) => data is T)
        .map((data) => data as T);
  }

  void off(String event) {
    _socket?.off(event);
    final controller = _eventControllers.remove(event);
    if (controller != null) unawaited(controller.close());
  }

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

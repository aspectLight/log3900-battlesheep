import 'dart:async';

import 'package:fpdart/fpdart.dart';

import '../../../core/exceptions/socket_exception.dart';

abstract class SocketService {
  bool get isConnected;
  Stream<bool> get connectionStream;
  Stream<dynamic> get errorStream;

  TaskEither<SocketException, Unit> connect(String url);
  void disconnect();
  void emit(String event, [dynamic data]);
  Stream<dynamic> on(String event);
  void off(String event);
  void dispose();
}

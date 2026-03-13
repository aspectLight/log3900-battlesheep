import 'dart:async';

import '../services/socket_service.dart';

StreamSubscription<dynamic> subscribeSocketEvent<T>(
  SocketService socketService,
  String event,
  StreamController<dynamic> controller,
  dynamic Function(T) parse,
) {
  return socketService.on<T>(event).listen((data) {
    if (!controller.isClosed) controller.add(parse(data));
  });
}

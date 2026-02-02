import 'dart:async';

abstract class SocketChatService {
  Stream<bool> get connectionStream;
  Stream<Map<String, dynamic>> get messageReceivedStream;
  Stream<List<dynamic>> get messagesHistoryStream;
  Stream<dynamic> get errorStream;

  bool get isConnected;

  void getGeneralChatMessages();
  void sendMessage({required String username, required String message});

  Future<void> dispose();
}

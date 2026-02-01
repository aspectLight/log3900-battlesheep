abstract interface class SocketChatService {
  Stream<bool> get connectionStream;
  Stream<Map<String, dynamic>> get messageReceivedStream;
  Stream<List<dynamic>> get messagesHistoryStream;
  Stream<dynamic> get errorStream;
  bool get isConnected;

  void connect(String username);
  void disconnect();
  void joinGeneralChat(String username);
  void getGeneralChatMessages();
  void sendMessage({required String username, required String message});
  Future<void> dispose();
}

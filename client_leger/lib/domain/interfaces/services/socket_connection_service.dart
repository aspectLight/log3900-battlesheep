abstract class SocketConnectionService {
  bool get isConnected;
  String? get currentUsername;

  void connect(String username);
  void disconnect();

  void dispose();
}

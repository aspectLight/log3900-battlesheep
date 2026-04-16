class SessionCredentials {
  String? _token;
  String? _sessionId;

  String? get token => _token;
  String? get sessionId => _sessionId;

  bool get hasCredentials => _token != null && _sessionId != null;

  void save({required String token, required String sessionId}) {
    _token = token;
    _sessionId = sessionId;
  }

  void clear() {
    _token = null;
    _sessionId = null;
  }
}

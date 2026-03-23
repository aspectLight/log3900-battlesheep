/// Data contract for an authenticated, connected user session
///
/// # Purpose
/// This represents a single authenticated user who is connected to the server.
/// It's the minimal data needed to know "who is logged in and talking to what server".
///
/// # When This Exists
/// - Created after successful authentication
/// - Updated when WebSocket connects
/// - Cleared when user logs out
///
/// Authentication (username) and WebSocket connection (socketId) happen at different times:
/// 1. User signs in → username set, socketId empty
/// 2. WebSocket connects → socketId populated
class ConnectedSession {
  const ConnectedSession({required this.username, required this.socketId});

  final String username;
  final String socketId;
}

class ApiEndpoints {
  // Auth Routes
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String userProfile = '/auth/profile';
  static const String logout = '/auth/logout';
  static const String deleteAccount = '/auth/account';
  static const String getEmailByUsername = '/auth/get-email-by-username';
  static const String loginHistory = '/auth/history/logins';
  static const String gameHistory = '/auth/history/games';
  static const String startGameHistory = '/auth/history/games/start';
  static const String endGameHistory = '/auth/history/games/end';
  static const String abandonGameHistory = '/auth/history/games/abandon';
}

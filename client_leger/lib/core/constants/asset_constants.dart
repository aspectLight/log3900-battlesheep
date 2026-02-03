class AssetConstants {
  static const String background = 'assets/images/background.png';
  static const String snow = 'assets/images/snow.gif';
  static const String loading = 'assets/images/loading.gif';
  static const String logo = 'assets/images/logo.png';

  static const Map<String, String> avatars = {
    'dmitry': 'assets/images/avatars/dmitryAvatar.png',
    'georgie': 'assets/images/avatars/georgieAvatar.png',
    'gorkina': 'assets/images/avatars/gorkinaAvatar.png',
    'irina': 'assets/images/avatars/irinaAvatar.png',
    'ivanov': 'assets/images/avatars/ivanovAvatar.png',
    'ladeve': 'assets/images/avatars/ladeveAvatar.png',
    'misha': 'assets/images/avatars/mishaAvatar.png',
    'petrov': 'assets/images/avatars/petrovAvatar.png',
    'sergei': 'assets/images/avatars/sergeiAvatar.png',
    'sokolov': 'assets/images/avatars/sokolovAvatar.png',
    'viktor': 'assets/images/avatars/viktorAvatar.png',
    'volkov': 'assets/images/avatars/volkovAvatar.png',
  };

  static List<String> get avatarPaths => avatars.values.toList();
  static List<String> get avatarIds => avatars.keys.toList();
}

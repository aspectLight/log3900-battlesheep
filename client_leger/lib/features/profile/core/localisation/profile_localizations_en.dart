// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'profile_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class ProfileLocalizationsEn extends ProfileLocalizations {
  ProfileLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get profileTitle => 'Profile configuration';

  @override
  String get profileBack => 'Back';

  @override
  String get profileUsernameLabel => 'Username';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profileAvatarLabel => 'Avatar';

  @override
  String get profileSave => 'Save changes';

  @override
  String get profileSaveInProgress => 'Saving...';

  @override
  String get profileFillAllFieldsError =>
      'Please fill all fields and select an avatar.';

  @override
  String get profileStatisticsTitle => 'Statistics';

  @override
  String get profileClassicGames => 'Classic games';

  @override
  String get profileCtfGames => 'CTF games';

  @override
  String get profileGamesWon => 'Games won';

  @override
  String get profileAverageTime => 'Average time per game';

  @override
  String get profileDeleteAccount => 'Delete account';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'profile_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class ProfileLocalizationsFr extends ProfileLocalizations {
  ProfileLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get profileTitle => 'Configuration du profil';

  @override
  String get profileBack => 'Retour';

  @override
  String get profileUsernameLabel => 'Pseudonyme';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profileAvatarLabel => 'Avatar';

  @override
  String get profileSave => 'Enregistrer les modifications';

  @override
  String get profileSaveInProgress => 'Enregistrement...';

  @override
  String get profileFillAllFieldsError =>
      'Veuillez remplir tous les champs et sélectionner un avatar.';

  @override
  String get profileStatisticsTitle => 'Statistiques';

  @override
  String get profileClassicGames => 'Parties classiques';

  @override
  String get profileCtfGames => 'Parties CTF';

  @override
  String get profileGamesWon => 'Parties gagnées';

  @override
  String get profileAverageTime => 'Temps moyen par partie';

  @override
  String get profileDeleteAccount => 'Supprimer le compte';
}

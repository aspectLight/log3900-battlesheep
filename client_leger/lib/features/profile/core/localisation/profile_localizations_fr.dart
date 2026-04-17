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
  String get profileAvatarUploadLabel => 'Importer une photo';

  @override
  String get profileAvatarCameraLabel => 'Prendre une photo';

  @override
  String get profileAvatarOrUpload => 'Ou importer une photo personnalisée';

  @override
  String get profileAvatarFileTooLarge => 'L\'image doit faire moins de 2 Mo.';

  @override
  String get profileAvatarInvalidFileType =>
      'Seuls les formats JPG et PNG sont acceptés.';

  @override
  String get profileAvatarUploadFailed =>
      'Échec du téléversement de l\'avatar. L\'avatar précédent a été conservé.';

  @override
  String get profileAvatarUploading => 'Téléversement...';

  @override
  String get profileSave => 'Enregistrer les modifications';

  @override
  String get profileSaveInProgress => 'Enregistrement...';

  @override
  String get profileSuccessTitle => 'Succès';

  @override
  String get profileErrorTitle => 'Erreur';

  @override
  String get profileSaveSuccess => 'Profil mis à jour avec succès.';

  @override
  String get profileFillAllFieldsError =>
      'Veuillez remplir tous les champs et sélectionner un avatar.';

  @override
  String get profileNetworkError =>
      'Problème de connexion réseau. Vérifiez votre connexion et réessayez.';

  @override
  String get profileUnauthorizedError =>
      'Session expirée ou non autorisée. Veuillez vous reconnecter.';

  @override
  String get profileUsernameTaken => 'Ce pseudonyme est déjà utilisé.';

  @override
  String get profileEmailTaken => 'Cette adresse courriel est déjà utilisée.';

  @override
  String get profileInvalidDataError =>
      'Les informations saisies sont invalides. Vérifiez les champs et réessayez.';

  @override
  String get profileForbiddenError =>
      'Cette action n\'est pas autorisée. Vous devez peut-être débloquer cet élément à la boutique.';

  @override
  String get profileNotFoundError => 'Le profil est introuvable.';

  @override
  String get profileServerError =>
      'Erreur du serveur. Veuillez réessayer plus tard.';

  @override
  String get profileUnexpectedError =>
      'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get profileNoChanges => 'Aucune modification à enregistrer.';

  @override
  String get profileRetry => 'Réessayer';

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
  String get profileThemeLabel => 'Thème visuel';

  @override
  String get profileLanguageLabel => 'Langue';

  @override
  String get themeNameDefault => 'Classique';

  @override
  String get themeNameFrost => 'Froid Sibérien';

  @override
  String get themeNameVillage => 'Village Abandonné';

  @override
  String get profileDeleteAccount => 'Supprimer le compte';

  @override
  String get profileDeleteConfirmTitle => 'Supprimer le compte ?';

  @override
  String get profileDeleteConfirmBody =>
      'Cette action est permanente. Votre compte et vos données seront supprimés.';

  @override
  String get profileCancel => 'Annuler';

  @override
  String get profileConfirmDelete => 'Supprimer';

  @override
  String get profileDeleting => 'Suppression...';

  @override
  String get languageNameFr => 'Français';

  @override
  String get languageNameEn => 'Anglais';

  @override
  String get tutorial => 'Tutoriel';

  @override
  String get continueTutorial => 'Continuer';
}

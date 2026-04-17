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
  String get profileAvatarUploadLabel => 'Upload photo';

  @override
  String get profileAvatarCameraLabel => 'Take photo';

  @override
  String get profileAvatarOrUpload => 'Or upload a custom photo';

  @override
  String get profileAvatarFileTooLarge => 'Image must be under 2 MB.';

  @override
  String get profileAvatarInvalidFileType =>
      'Only JPG and PNG images are accepted.';

  @override
  String get profileAvatarUploadFailed =>
      'Avatar upload failed. Your previous avatar was kept.';

  @override
  String get profileAvatarUploading => 'Uploading...';

  @override
  String get profileSave => 'Save changes';

  @override
  String get profileSaveInProgress => 'Saving...';

  @override
  String get profileSuccessTitle => 'Success';

  @override
  String get profileErrorTitle => 'Error';

  @override
  String get profileSaveSuccess => 'Profile updated successfully.';

  @override
  String get profileFillAllFieldsError =>
      'Please fill all fields and select an avatar.';

  @override
  String get profileNetworkError =>
      'Network connection problem. Check your connection and try again.';

  @override
  String get profileUnauthorizedError =>
      'Session expired or unauthorized. Please sign in again.';

  @override
  String get profileUsernameTaken => 'This username is already in use.';

  @override
  String get profileEmailTaken => 'This email is already in use.';

  @override
  String get profileInvalidDataError =>
      'The information entered is invalid. Check your fields and try again.';

  @override
  String get profileForbiddenError =>
      'This action is not allowed. You may need to unlock this item in the shop first.';

  @override
  String get profileNotFoundError => 'Profile could not be found.';

  @override
  String get profileServerError => 'Server error. Please try again later.';

  @override
  String get profileUnexpectedError =>
      'Something went wrong. Please try again.';

  @override
  String get profileNoChanges => 'No changes to save.';

  @override
  String get profileRetry => 'Retry';

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
  String get profileThemeLabel => 'Visual Theme';

  @override
  String get profileLanguageLabel => 'Language';

  @override
  String get themeNameDefault => 'Classic';

  @override
  String get themeNameFrost => 'Siberian Cold';

  @override
  String get themeNameVillage => 'Abandonned Village';

  @override
  String get profileDeleteAccount => 'Delete account';

  @override
  String get profileDeleteConfirmTitle => 'Delete account?';

  @override
  String get profileDeleteConfirmBody =>
      'This action is permanent. Your account and data will be removed.';

  @override
  String get profileCancel => 'Cancel';

  @override
  String get profileConfirmDelete => 'Delete';

  @override
  String get languageNameFr => 'French';

  @override
  String get languageNameEn => 'English';

  @override
  String get profileDeleting => 'Deleting...';

  @override
  String get tutorial => 'Tutorial';

  @override
  String get continueTutorial => 'Continue';
}

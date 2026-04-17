import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'profile_localizations_en.dart';
import 'profile_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of ProfileLocalizations
/// returned by `ProfileLocalizations.of(context)`.
///
/// Applications need to include `ProfileLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localisation/profile_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: ProfileLocalizations.localizationsDelegates,
///   supportedLocales: ProfileLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the ProfileLocalizations.supportedLocales
/// property.
abstract class ProfileLocalizations {
  ProfileLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static ProfileLocalizations? of(BuildContext context) {
    return Localizations.of<ProfileLocalizations>(
      context,
      ProfileLocalizations,
    );
  }

  static const LocalizationsDelegate<ProfileLocalizations> delegate =
      _ProfileLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile configuration'**
  String get profileTitle;

  /// No description provided for @profileBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get profileBack;

  /// No description provided for @profileUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get profileUsernameLabel;

  /// No description provided for @profileEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmailLabel;

  /// No description provided for @profileAvatarLabel.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get profileAvatarLabel;

  /// No description provided for @profileAvatarUploadLabel.
  ///
  /// In en, this message translates to:
  /// **'Upload photo'**
  String get profileAvatarUploadLabel;

  /// No description provided for @profileAvatarCameraLabel.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get profileAvatarCameraLabel;

  /// No description provided for @profileAvatarOrUpload.
  ///
  /// In en, this message translates to:
  /// **'Or upload a custom photo'**
  String get profileAvatarOrUpload;

  /// No description provided for @profileAvatarFileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Image must be under 2 MB.'**
  String get profileAvatarFileTooLarge;

  /// No description provided for @profileAvatarInvalidFileType.
  ///
  /// In en, this message translates to:
  /// **'Only JPG and PNG images are accepted.'**
  String get profileAvatarInvalidFileType;

  /// No description provided for @profileAvatarUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Avatar upload failed. Your previous avatar was kept.'**
  String get profileAvatarUploadFailed;

  /// No description provided for @profileAvatarUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get profileAvatarUploading;

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profileSave;

  /// No description provided for @profileSaveInProgress.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get profileSaveInProgress;

  /// No description provided for @profileSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get profileSuccessTitle;

  /// No description provided for @profileErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get profileErrorTitle;

  /// No description provided for @profileSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get profileSaveSuccess;

  /// No description provided for @profileFillAllFieldsError.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields and select an avatar.'**
  String get profileFillAllFieldsError;

  /// No description provided for @profileNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network connection problem. Check your connection and try again.'**
  String get profileNetworkError;

  /// No description provided for @profileUnauthorizedError.
  ///
  /// In en, this message translates to:
  /// **'Session expired or unauthorized. Please sign in again.'**
  String get profileUnauthorizedError;

  /// No description provided for @profileUsernameTaken.
  ///
  /// In en, this message translates to:
  /// **'This username is already in use.'**
  String get profileUsernameTaken;

  /// No description provided for @profileEmailTaken.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use.'**
  String get profileEmailTaken;

  /// No description provided for @profileInvalidDataError.
  ///
  /// In en, this message translates to:
  /// **'The information entered is invalid. Check your fields and try again.'**
  String get profileInvalidDataError;

  /// No description provided for @profileForbiddenError.
  ///
  /// In en, this message translates to:
  /// **'This action is not allowed. You may need to unlock this item in the shop first.'**
  String get profileForbiddenError;

  /// No description provided for @profileNotFoundError.
  ///
  /// In en, this message translates to:
  /// **'Profile could not be found.'**
  String get profileNotFoundError;

  /// No description provided for @profileServerError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get profileServerError;

  /// No description provided for @profileUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get profileUnexpectedError;

  /// No description provided for @profileNoChanges.
  ///
  /// In en, this message translates to:
  /// **'No changes to save.'**
  String get profileNoChanges;

  /// No description provided for @profileRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get profileRetry;

  /// No description provided for @profileStatisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get profileStatisticsTitle;

  /// No description provided for @profileClassicGames.
  ///
  /// In en, this message translates to:
  /// **'Classic games'**
  String get profileClassicGames;

  /// No description provided for @profileCtfGames.
  ///
  /// In en, this message translates to:
  /// **'CTF games'**
  String get profileCtfGames;

  /// No description provided for @profileGamesWon.
  ///
  /// In en, this message translates to:
  /// **'Games won'**
  String get profileGamesWon;

  /// No description provided for @profileAverageTime.
  ///
  /// In en, this message translates to:
  /// **'Average time per game'**
  String get profileAverageTime;

  /// No description provided for @profileThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get profileThemeLabel;

  /// No description provided for @profileLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguageLabel;

  /// No description provided for @languageNameFr.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageNameFr;

  /// No description provided for @languageNameEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageNameEn;

  /// No description provided for @themeNameDefault.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get themeNameDefault;

  /// No description provided for @themeNameFrost.
  ///
  /// In en, this message translates to:
  /// **'Siberian Cold'**
  String get themeNameFrost;

  /// No description provided for @themeNameVillage.
  ///
  /// In en, this message translates to:
  /// **'Abandonned Village'**
  String get themeNameVillage;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get profileDeleteAccount;

  /// No description provided for @profileDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get profileDeleteConfirmTitle;

  /// No description provided for @profileDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent. Your account and data will be removed.'**
  String get profileDeleteConfirmBody;

  /// No description provided for @profileCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileCancel;

  /// No description provided for @profileConfirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get profileConfirmDelete;

  /// No description provided for @profileDeleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get profileDeleting;

  /// No description provided for @tutorial.
  ///
  /// In en, this message translates to:
  /// **'Tutorial'**
  String get tutorial;

  /// No description provided for @continueTutorial.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueTutorial;
}

class _ProfileLocalizationsDelegate
    extends LocalizationsDelegate<ProfileLocalizations> {
  const _ProfileLocalizationsDelegate();

  @override
  Future<ProfileLocalizations> load(Locale locale) {
    return SynchronousFuture<ProfileLocalizations>(
      lookupProfileLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_ProfileLocalizationsDelegate old) => false;
}

ProfileLocalizations lookupProfileLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return ProfileLocalizationsEn();
    case 'fr':
      return ProfileLocalizationsFr();
  }

  throw FlutterError(
    'ProfileLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

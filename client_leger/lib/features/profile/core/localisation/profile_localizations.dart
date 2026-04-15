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

  /// No description provided for @profileFillAllFieldsError.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields and select an avatar.'**
  String get profileFillAllFieldsError;

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

  /// No description provided for @profileDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get profileDeleteAccount;

  String get profileThemeLabel;

  String get profileLanguageLabel;

  String get themeNameDefault;

  String get themeNameFrost;

  String get themeNameVillage;

  String get languageNameFr;

  String get languageNameEn;

  String get tutorial;

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

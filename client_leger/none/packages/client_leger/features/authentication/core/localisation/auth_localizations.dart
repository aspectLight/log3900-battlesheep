import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'auth_localizations_en.dart';
import 'auth_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AuthLocalizations
/// returned by `AuthLocalizations.of(context)`.
///
/// Applications need to include `AuthLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localisation/auth_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AuthLocalizations.localizationsDelegates,
///   supportedLocales: AuthLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AuthLocalizations.supportedLocales
/// property.
abstract class AuthLocalizations {
  AuthLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AuthLocalizations? of(BuildContext context) {
    return Localizations.of<AuthLocalizations>(context, AuthLocalizations);
  }

  static const LocalizationsDelegate<AuthLocalizations> delegate =
      _AuthLocalizationsDelegate();

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

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing In...'**
  String get signingIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signingUp.
  ///
  /// In en, this message translates to:
  /// **'Creating Account...'**
  String get signingUp;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @usernamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'JohnDoe'**
  String get usernamePlaceholder;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'johndoe@example.com'**
  String get emailPlaceholder;

  /// No description provided for @passwordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get passwordPlaceholder;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get usernameRequired;

  /// No description provided for @usernameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get usernameTooShort;

  /// No description provided for @usernameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Username must be at most 15 characters'**
  String get usernameTooLong;

  /// No description provided for @usernameSpecialChars.
  ///
  /// In en, this message translates to:
  /// **'Special characters not allowed'**
  String get usernameSpecialChars;

  /// No description provided for @usernameInvalidLength.
  ///
  /// In en, this message translates to:
  /// **'Username must be between 3 and 15 characters'**
  String get usernameInvalidLength;

  /// No description provided for @identifierRequired.
  ///
  /// In en, this message translates to:
  /// **'Username or Email is required'**
  String get identifierRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordLeastOneLetter.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one letter'**
  String get passwordLeastOneLetter;

  /// No description provided for @passwordLeastOneDigit.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one digit'**
  String get passwordLeastOneDigit;

  /// No description provided for @passwordNoSpaces.
  ///
  /// In en, this message translates to:
  /// **'Password must not contain spaces'**
  String get passwordNoSpaces;

  /// No description provided for @confirmationRequired.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get confirmationRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @avatarTitle.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get avatarTitle;

  /// No description provided for @avatarRequired.
  ///
  /// In en, this message translates to:
  /// **'Select an avatar'**
  String get avatarRequired;

  /// No description provided for @avatarUploadLabel.
  ///
  /// In en, this message translates to:
  /// **'Upload photo'**
  String get avatarUploadLabel;

  /// No description provided for @avatarCameraLabel.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get avatarCameraLabel;

  /// No description provided for @avatarCustomHint.
  ///
  /// In en, this message translates to:
  /// **'Or choose a custom avatar'**
  String get avatarCustomHint;

  /// No description provided for @avatarFileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Image must be under 2 MB.'**
  String get avatarFileTooLarge;

  /// No description provided for @avatarInvalidFileType.
  ///
  /// In en, this message translates to:
  /// **'Only JPG and PNG images are accepted.'**
  String get avatarInvalidFileType;

  /// No description provided for @avatarUploadFallbackWarning.
  ///
  /// In en, this message translates to:
  /// **'Avatar upload failed. The default avatar was kept.'**
  String get avatarUploadFallbackWarning;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect username or password'**
  String get invalidCredentials;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use'**
  String get emailAlreadyInUse;

  /// No description provided for @usernameAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This username is already in use'**
  String get usernameAlreadyInUse;

  /// No description provided for @accountAlreadyConnected.
  ///
  /// In en, this message translates to:
  /// **'This account is already connected on another device.'**
  String get accountAlreadyConnected;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account exists with this identifier'**
  String get userNotFound;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network connection problem'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get serverError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// No description provided for @teamName.
  ///
  /// In en, this message translates to:
  /// **'Team 105'**
  String get teamName;

  /// No description provided for @teamMembers.
  ///
  /// In en, this message translates to:
  /// **'Ahmed Sami Benabbou, May Guessous, Ayoub Marfouk, Pierre Carré, Anis Gadouche, Djihed Benaiche'**
  String get teamMembers;
}

class _AuthLocalizationsDelegate
    extends LocalizationsDelegate<AuthLocalizations> {
  const _AuthLocalizationsDelegate();

  @override
  Future<AuthLocalizations> load(Locale locale) {
    return SynchronousFuture<AuthLocalizations>(
      lookupAuthLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AuthLocalizationsDelegate old) => false;
}

AuthLocalizations lookupAuthLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AuthLocalizationsEn();
    case 'fr':
      return AuthLocalizationsFr();
  }

  throw FlutterError(
    'AuthLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

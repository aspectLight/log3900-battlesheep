import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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

  /// Welcome message on the home screen
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {username}'**
  String welcomeUser(String username);

  /// Placeholder text for upcoming game features
  ///
  /// In en, this message translates to:
  /// **'Game content coming soon...'**
  String get gameContentSoon;

  /// Button text to create a new account
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Subtitle text encouraging signup
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started'**
  String get signUpToStart;

  /// Title for the main menu screen
  ///
  /// In en, this message translates to:
  /// **'Main Menu'**
  String get mainMenu;

  /// Validation error when username is empty
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get usernameRequired;

  /// Validation error when identifier is empty
  ///
  /// In en, this message translates to:
  /// **'Username or Email is required'**
  String get identifierRequired;

  /// Validation error for invalid email format
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmail;

  /// Validation error for short username
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get usernameTooShort;

  /// Validation error for long username
  ///
  /// In en, this message translates to:
  /// **'Username must be at most 15 characters'**
  String get usernameTooLong;

  /// Validation error for special characters in username
  ///
  /// In en, this message translates to:
  /// **'Special characters not allowed'**
  String get usernameSpecialChars;

  /// Validation error for username length not within range
  ///
  /// In en, this message translates to:
  /// **'Username must be between 3 and 15 characters'**
  String get usernameInvalidLength;

  /// Validation error when password is empty
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get passwordRequired;

  /// Validation error for short password
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get passwordTooShort;

  /// Validation error for missing letter in password
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one letter'**
  String get passwordLeastOneLetter;

  /// Validation error for missing digit in password
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one digit'**
  String get passwordLeastOneDigit;

  /// Validation error for spaces in password
  ///
  /// In en, this message translates to:
  /// **'Password must not contain spaces'**
  String get passwordNoSpaces;

  /// Validation error when confirmation is missing
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get confirmationRequired;

  /// Validation error when passwords differ
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Validation error when email is empty
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get emailRequired;

  /// Title or greeting for returning users
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Subtitle text encouraging sign in
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// Label for username or email input field
  ///
  /// In en, this message translates to:
  /// **'Username or Email'**
  String get usernameOrEmail;

  /// Label for username input field
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Label for email input field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Label for password input field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Label for confirm password input field
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Button text to sign in
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Button text while signing in
  ///
  /// In en, this message translates to:
  /// **'Signing In...'**
  String get signingIn;

  /// Button text to sign up
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Button text while creating an account
  ///
  /// In en, this message translates to:
  /// **'Creating Account...'**
  String get signingUp;

  /// Text asking if user has no account
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccount;

  /// Text asking if user already has an account
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// Error message for invalid login credentials
  ///
  /// In en, this message translates to:
  /// **'Incorrect username or password'**
  String get invalidCredentials;

  /// Error message when registering with existing email
  ///
  /// In en, this message translates to:
  /// **'This email is already in use'**
  String get emailAlreadyInUse;

  /// Error message when registering with existing username
  ///
  /// In en, this message translates to:
  /// **'This username is already in use'**
  String get usernameAlreadyInUse;

  /// Error message when user is already logged in elsewhere
  ///
  /// In en, this message translates to:
  /// **'This account is already connected on another device.'**
  String get accountAlreadyConnected;

  /// Error message when user is not found
  ///
  /// In en, this message translates to:
  /// **'No account exists with this identifier'**
  String get userNotFound;

  /// Error message for network issues
  ///
  /// In en, this message translates to:
  /// **'Network connection problem'**
  String get networkError;

  /// Error message for server issues
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get serverError;

  /// Error message for unknown issues
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// Title or label for the chat feature
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// Placeholder text when chat is empty
  ///
  /// In en, this message translates to:
  /// **'No messages yet. Start the conversation!'**
  String get noMessages;

  /// Placeholder text for message input field
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// Label for back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Title for the avatar selection section
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get avatarTitle;

  /// Placeholder text for the username input field
  ///
  /// In en, this message translates to:
  /// **'JohnDoe'**
  String get usernamePlaceholder;

  /// Placeholder text for the email input field
  ///
  /// In en, this message translates to:
  /// **'johndoe@example.com'**
  String get emailPlaceholder;

  /// Placeholder text for the password input field
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get passwordPlaceholder;

  /// Team name displayed in the footer
  ///
  /// In en, this message translates to:
  /// **'Team 105'**
  String get teamName;

  /// Validation error when avatar is not selected
  ///
  /// In en, this message translates to:
  /// **'Select an avatar'**
  String get avatarRequired;

  /// List of team members displayed in the footer
  ///
  /// In en, this message translates to:
  /// **'Ahmed Sami Benabbou, May Guessous, Ayoub Marfouk, Pierre Carré, Anis Gadouche, Djihed Benaiche'**
  String get teamMembers;

  /// Button text to join a game
  ///
  /// In en, this message translates to:
  /// **'Join Game'**
  String get joinGame;

  /// Button text to create a game
  ///
  /// In en, this message translates to:
  /// **'Create Game'**
  String get createGame;

  /// Button text to administer games
  ///
  /// In en, this message translates to:
  /// **'Administer Games'**
  String get administerGames;

  /// Tooltip for the settings button
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Menu option to view profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Menu option to sign out
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Menu option to view connection history
  ///
  /// In en, this message translates to:
  /// **'Connection History'**
  String get connectionHistory;

  /// Menu option to view games history
  ///
  /// In en, this message translates to:
  /// **'Games History'**
  String get gameHistory;

  /// Title of the Journal tab in the chatbox
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get journal;

  /// Message displayed when the journal is empty
  ///
  /// In en, this message translates to:
  /// **'The journal is empty for now'**
  String get emptyJournal;

  /// Text for filtering
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// Option for no filter
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// Text for the send message button
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

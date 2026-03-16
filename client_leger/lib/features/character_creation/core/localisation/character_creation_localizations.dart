import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'character_creation_localizations_en.dart';
import 'character_creation_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of CharacterCreationLocalizations
/// returned by `CharacterCreationLocalizations.of(context)`.
///
/// Applications need to include `CharacterCreationLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localisation/character_creation_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: CharacterCreationLocalizations.localizationsDelegates,
///   supportedLocales: CharacterCreationLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the CharacterCreationLocalizations.supportedLocales
/// property.
abstract class CharacterCreationLocalizations {
  CharacterCreationLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static CharacterCreationLocalizations? of(BuildContext context) {
    return Localizations.of<CharacterCreationLocalizations>(
      context,
      CharacterCreationLocalizations,
    );
  }

  static const LocalizationsDelegate<CharacterCreationLocalizations> delegate =
      _CharacterCreationLocalizationsDelegate();

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

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @backToCreateGame.
  ///
  /// In en, this message translates to:
  /// **'Create game'**
  String get backToCreateGame;

  /// No description provided for @createPlayerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create player'**
  String get createPlayerTitle;

  /// No description provided for @charactersSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get charactersSectionTitle;

  /// No description provided for @chooseCharacterPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Choose your character'**
  String get chooseCharacterPlaceholder;

  /// No description provided for @characterNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get characterNameLabel;

  /// No description provided for @createGameButton.
  ///
  /// In en, this message translates to:
  /// **'Create game'**
  String get createGameButton;

  /// No description provided for @accessWaitingRoomButton.
  ///
  /// In en, this message translates to:
  /// **'Access waiting room'**
  String get accessWaitingRoomButton;

  /// No description provided for @playerHudStatsSection.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get playerHudStatsSection;

  /// No description provided for @statHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get statHealth;

  /// No description provided for @statHealthDescription.
  ///
  /// In en, this message translates to:
  /// **'Represents the character hit points. If it reaches zero, the player is defeated.'**
  String get statHealthDescription;

  /// No description provided for @statSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get statSpeed;

  /// No description provided for @statSpeedDescription.
  ///
  /// In en, this message translates to:
  /// **'Determines turn order in combat and movement points per turn.'**
  String get statSpeedDescription;

  /// No description provided for @statAttack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get statAttack;

  /// No description provided for @statAttackDescription.
  ///
  /// In en, this message translates to:
  /// **'Determines damage dealt to opponents.'**
  String get statAttackDescription;

  /// No description provided for @statDefense.
  ///
  /// In en, this message translates to:
  /// **'Defense'**
  String get statDefense;

  /// No description provided for @statDefenseDescription.
  ///
  /// In en, this message translates to:
  /// **'Represents the ability to block damage from enemy attacks.'**
  String get statDefenseDescription;

  /// No description provided for @characterCreationValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'Please choose a character and the 2 bonuses.'**
  String get characterCreationValidationMessage;

  /// No description provided for @selectedGameHiddenOrDeleted.
  ///
  /// In en, this message translates to:
  /// **'The selected game is hidden or deleted.'**
  String get selectedGameHiddenOrDeleted;

  /// No description provided for @reserveCharacterFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not reserve character.'**
  String get reserveCharacterFailed;
}

class _CharacterCreationLocalizationsDelegate
    extends LocalizationsDelegate<CharacterCreationLocalizations> {
  const _CharacterCreationLocalizationsDelegate();

  @override
  Future<CharacterCreationLocalizations> load(Locale locale) {
    return SynchronousFuture<CharacterCreationLocalizations>(
      lookupCharacterCreationLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_CharacterCreationLocalizationsDelegate old) => false;
}

CharacterCreationLocalizations lookupCharacterCreationLocalizations(
  Locale locale,
) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return CharacterCreationLocalizationsEn();
    case 'fr':
      return CharacterCreationLocalizationsFr();
  }

  throw FlutterError(
    'CharacterCreationLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

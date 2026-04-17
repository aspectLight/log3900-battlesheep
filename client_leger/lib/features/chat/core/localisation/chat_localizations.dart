import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'chat_localizations_en.dart';
import 'chat_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of ChatLocalizations
/// returned by `ChatLocalizations.of(context)`.
///
/// Applications need to include `ChatLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localisation/chat_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: ChatLocalizations.localizationsDelegates,
///   supportedLocales: ChatLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the ChatLocalizations.supportedLocales
/// property.
abstract class ChatLocalizations {
  ChatLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static ChatLocalizations? of(BuildContext context) {
    return Localizations.of<ChatLocalizations>(context, ChatLocalizations);
  }

  static const LocalizationsDelegate<ChatLocalizations> delegate =
      _ChatLocalizationsDelegate();

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

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @chatGeneralTab.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get chatGeneralTab;

  /// No description provided for @discussionCanals.
  ///
  /// In en, this message translates to:
  /// **'Discussion Channels'**
  String get discussionCanals;

  /// No description provided for @createChannel.
  ///
  /// In en, this message translates to:
  /// **'CREATE A NEW CHANNEL'**
  String get createChannel;

  /// No description provided for @channelNameHint.
  ///
  /// In en, this message translates to:
  /// **'Channel name (ex: ABC)'**
  String get channelNameHint;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @availableChannels.
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE CHANNELS'**
  String get availableChannels;

  /// No description provided for @searchChannelsHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a channel by name...'**
  String get searchChannelsHint;

  /// No description provided for @loadingChannels.
  ///
  /// In en, this message translates to:
  /// **'Loading channels...'**
  String get loadingChannels;

  /// No description provided for @noChannelsFound.
  ///
  /// In en, this message translates to:
  /// **'No channels match your search.'**
  String get noChannelsFound;

  /// No description provided for @channelName.
  ///
  /// In en, this message translates to:
  /// **'NAME'**
  String get channelName;

  /// No description provided for @channelCreator.
  ///
  /// In en, this message translates to:
  /// **'CREATOR'**
  String get channelCreator;

  /// No description provided for @channelActions.
  ///
  /// In en, this message translates to:
  /// **'ACTIONS'**
  String get channelActions;

  /// No description provided for @creatorBadge.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get creatorBadge;

  /// No description provided for @leaveChannel.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leaveChannel;

  /// No description provided for @joinChannel.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get joinChannel;

  /// No description provided for @deleteChannel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteChannel;

  /// No description provided for @confirmDeleteChannel.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete this channel?'**
  String get confirmDeleteChannel;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;
}

class _ChatLocalizationsDelegate
    extends LocalizationsDelegate<ChatLocalizations> {
  const _ChatLocalizationsDelegate();

  @override
  Future<ChatLocalizations> load(Locale locale) {
    return SynchronousFuture<ChatLocalizations>(
      lookupChatLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_ChatLocalizationsDelegate old) => false;
}

ChatLocalizations lookupChatLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return ChatLocalizationsEn();
    case 'fr':
      return ChatLocalizationsFr();
  }

  throw FlutterError(
    'ChatLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

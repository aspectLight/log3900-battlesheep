// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'chat_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class ChatLocalizationsEn extends ChatLocalizations {
  ChatLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get chat => 'Chat';

  @override
  String get send => 'Send';

  @override
  String get chatGeneralTab => 'General';

  @override
  String get discussionCanals => 'Discussion Channels';

  @override
  String get createChannel => "CREATE A NEW CHANNEL";

  @override
  String get channelNameHint => "Channel name (ex: ABC)";

  @override
  String get create => "Create";

  @override
  String get availableChannels => "AVAILABLE CHANNELS";

  @override
  String get searchChannelsHint => "Search for a channel by name...";

  @override
  String get loadingChannels => "Loading channels...";

  @override
  String get noChannelsFound => "No channels match your search.";

  @override
  String get channelName => "NAME";

  @override
  String get channelCreator => "CREATOR";

  @override
  String get channelActions => "ACTIONS";

  @override
  String get creatorBadge => "You";

  @override
  String get leaveChannel => "Leave";

  @override
  String get joinChannel => "Join";

  @override
  String get deleteChannel => "Delete";
}

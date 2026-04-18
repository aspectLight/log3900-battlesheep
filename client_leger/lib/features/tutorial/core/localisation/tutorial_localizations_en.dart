// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'tutorial_localizations.dart';

class TutorialLocalizationsEn extends TutorialLocalizations {
  TutorialLocalizationsEn([super.locale = 'en']);

  @override
  String get tutorialTitle => 'Tutorial';

  @override
  String get quit => 'Quit';

  @override
  String get finish => 'Finish';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileDesc =>
      'Customize your avatar, username, and preferences from the Profile view. Your game statistics are also available there. Furthermore, you have access to this tutorial at any time if needed.';

  @override
  String get friendsTitle => 'Friends';

  @override
  String get friendsDesc => 'Add friends, block enemies and manage requests.';

  @override
  String get chatTitle => 'Chat';

  @override
  String get chatDesc =>
      'Chat with other connected players in real-time through the general chat or custom channels. A vertical shake allows you to send the selected emoji, while a horizontal shake allows you to re-send the last message sent.';

  @override
  String get shopTitle => 'Shop';

  @override
  String get shopDesc =>
      'Purchase and equip new avatars and cosmetics with the coins you earn by playing.';

  @override
  String get gameModesTitle => 'Game modes';

  @override
  String get gameModesDesc =>
      'Two modes available: Classic (Reach 3 combat victories) and CTF (Capture the flag and bring it back to your campfire).';

  @override
  String get createGameTitle => 'Create a game';

  @override
  String get createGameDesc =>
      'Press "Create a Game" from the main menu, choose your map and settings (Private game only and entry fee), then wait for players to join or create virtual players controlled by AI.';

  @override
  String get joinGameTitle => 'Join a game';

  @override
  String get joinGameDesc =>
      'Press "Join a Game" from the main menu, then join a game through the list of availables games, using a code or with the associated QR code.';
}

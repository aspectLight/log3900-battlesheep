// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'chat_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class ChatLocalizationsFr extends ChatLocalizations {
  ChatLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get chat => 'Clavardage';

  @override
  String get send => 'Envoyer';

  @override
  String get chatGeneralTab => 'Général';

  @override
  String get discussionCanals => 'Canaux de discussion';

  @override
  String get createChannel => 'CRÉER UN NOUVEAU CANAL';

  @override
  String get channelNameHint => 'Nom du canal (ex: ABC)';

  @override
  String get create => 'Créer';

  @override
  String get availableChannels => 'CANAUX DISPONIBLES';

  @override
  String get searchChannelsHint => 'Rechercher un canal par nom...';

  @override
  String get loadingChannels => 'Chargement des canaux...';

  @override
  String get noChannelsFound => 'Aucun canal ne correspond à la recherche.';

  @override
  String get channelName => 'NOM';

  @override
  String get channelCreator => 'CRÉATEUR';

  @override
  String get channelActions => 'ACTIONS';

  @override
  String get creatorBadge => 'Vous';

  @override
  String get leaveChannel => 'Quitter';

  @override
  String get joinChannel => 'Joindre';

  @override
  String get deleteChannel => 'Supprimer';

  @override
  String get confirmDeleteChannel =>
      'Voulez-vous vraiment supprimer ce canal ?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'Non';
}

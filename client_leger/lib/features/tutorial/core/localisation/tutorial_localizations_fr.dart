// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'tutorial_localizations.dart';

class TutorialLocalizationsFr extends TutorialLocalizations {
  TutorialLocalizationsFr([super.locale = 'fr']);

  @override
  String get tutorialTitle => 'Tutoriel';

  @override
  String get quit => 'Quitter';

  @override
  String get finish => 'Terminer';

  @override
  String get next => 'Suivant';

  @override
  String get previous => 'Précédent';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileDesc =>
      'Personnalisez votre avatar, votre pseudo et vos préférences depuis la vue Profil. Vos statistiques de jeu y sont également disponibles.';

  @override
  String get friendsTitle => 'Amis';

  @override
  String get friendsDesc =>
      'Ajoutez des amis, bloquez vos ennemis et gérez vos demandes';

  @override
  String get chatTitle => 'Chat';

  @override
  String get chatDesc =>
      'Discutez en temps réel avec tous les joueurs connectés via le chat général, ou en privé à travers des canaux de communication customisés.';

  @override
  String get shopTitle => 'Boutique';

  @override
  String get shopDesc =>
      'Achetez de nouveaux avatars et cosmétiques avec vos pièces gagnées en jouant.';

  @override
  String get gameModesTitle => 'Modes de jeu';

  @override
  String get gameModesDesc =>
      'Deux modes disponibles : Classique (Atteignez 3 victoires en combat) et CTF (Capturez le drapeau et ramenez-le à votre feu de camp).';

  @override
  String get createGameTitle => 'Créer une partie';

  @override
  String get createGameDesc =>
      'Appuyez sur "Créer une partie" depuis le menu principal, choisissez votre mode, votre carte et vos paramètres, puis attendez que des joueurs vous rejoignent ou créez des joueurs controllés par IA.';

  @override
  String get joinGameTitle => 'Rejoindre une partie';

  @override
  String get joinGameDesc =>
      'Rejoignez une partie existante en utilisant un code d\'invitation.';
}

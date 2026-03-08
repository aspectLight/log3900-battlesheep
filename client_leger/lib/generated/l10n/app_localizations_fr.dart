// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String welcomeUser(String username) {
    return 'Bienvenue, $username';
  }

  @override
  String get gameContentSoon => 'Le contenu du jeu arrive bientôt...';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get signUpToStart => 'Inscrivez-vous pour commencer';

  @override
  String get mainMenu => 'Menu Principal';

  @override
  String get usernameRequired => 'Champ obligatoire';

  @override
  String get identifierRequired =>
      'Le nom d\'utilisateur ou le courriel est requis';

  @override
  String get invalidEmail => 'Format email invalide';

  @override
  String get usernameTooShort =>
      'Le nom d\'utilisateur doit comporter au moins 3 caractères';

  @override
  String get usernameTooLong =>
      'Le nom d\'utilisateur doit comporter au plus 15 caractères';

  @override
  String get usernameSpecialChars => 'Caractères spéciaux non autorisés';

  @override
  String get usernameInvalidLength =>
      'Le nom d\'utilisateur doit contenir entre 3 et 15 caractères';

  @override
  String get passwordRequired => 'Champ obligatoire';

  @override
  String get passwordTooShort => 'Minimum 8 caractères';

  @override
  String get passwordLeastOneLetter =>
      'Le mot de passe doit contenir au moins une lettre';

  @override
  String get passwordLeastOneDigit =>
      'Le mot de passe doit contenir au moins un chiffre';

  @override
  String get passwordNoSpaces =>
      'Le mot de passe ne doit pas contenir d\'espace';

  @override
  String get confirmationRequired => 'Champ obligatoire';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get emailRequired => 'Champ obligatoire';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get signInToContinue => 'Connectez-vous pour continuer';

  @override
  String get usernameOrEmail => 'Nom d\'utilisateur ou Courriel';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get email => 'Adresse courriel';

  @override
  String get password => 'Mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signingIn => 'Connexion...';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get signingUp => 'Création...';

  @override
  String get noAccount => 'Pas encore de compte ? ';

  @override
  String get alreadyHaveAccount => 'Déjà un compte ? ';

  @override
  String get invalidCredentials => 'Identifiant ou mot de passe incorrect.';

  @override
  String get emailAlreadyInUse => 'Ce courriel est déjà utilisé';

  @override
  String get usernameAlreadyInUse => 'Ce nom d\'utilisateur est déjà utilisé';

  @override
  String get accountAlreadyConnected =>
      'Ce compte est déjà connecté sur un autre appareil.';

  @override
  String get userNotFound => 'Aucun compte n\'existe avec cet identifiant.';

  @override
  String get networkError => 'Problème de connexion réseau';

  @override
  String get serverError => 'Erreur du serveur';

  @override
  String get unknownError => 'Une erreur inconnue est survenue';

  @override
  String get chat => 'Clavardage';

  @override
  String get noMessages =>
      'Aucun message pour l\'instant. Commencez la conversation !';

  @override
  String get typeMessage => 'Tapez un message...';

  @override
  String get back => 'Retour';

  @override
  String get avatarTitle => 'Avatar';

  @override
  String get usernamePlaceholder => 'JohnDoe';

  @override
  String get emailPlaceholder => 'johndoe@example.com';

  @override
  String get passwordPlaceholder => '••••••••';

  @override
  String get teamName => 'Équipe 105';

  @override
  String get avatarRequired => 'Sélectionnez un avatar';

  @override
  String get teamMembers =>
      'Ahmed Sami Benabbou, May Guessous, Ayoub Marfouk, Pierre Carré, Anis Gadouche, Djihed Benaiche';

  @override
  String get joinGame => 'Joindre une partie';

  @override
  String get createGame => 'Créer une partie';

  @override
  String get administerGames => 'Administrer les jeux';

  @override
  String get settings => 'Paramètres';

  @override
  String get profile => 'Profil';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get connectionHistory => 'Historique de connexion';

  @override
  String get gameHistory => 'Historique des parties';

  @override
  String get filter => 'Filtrer';

  @override
  String get none => 'Aucun';

  @override
  String get send => 'Envoyer';

  @override
  String get leaveGame => 'Quitter la partie';

  @override
  String get action => 'Action';

  @override
  String get date => 'Date';

  @override
  String get time => 'Heure';

  @override
  String get noEntries => 'Aucune entrée';

  @override
  String get result => 'Résultat';

  @override
  String get abandoned => 'Abandonnée';
}

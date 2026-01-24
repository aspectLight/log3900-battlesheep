// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String welcomeUser(Object username) {
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
  String get usernameRequired => 'Le nom d\'utilisateur est requis';

  @override
  String get identifierRequired =>
      'Le nom d\'utilisateur ou le courriel est requis';

  @override
  String get invalidEmail => 'Veuillez entrer une adresse courriel valide';

  @override
  String get usernameTooShort =>
      'Le nom d\'utilisateur doit comporter au moins 3 caractères';

  @override
  String get usernameTooLong =>
      'Le nom d\'utilisateur doit comporter au plus 15 caractères';

  @override
  String get usernameSpecialChars =>
      'Le nom d\'utilisateur ne doit pas contenir de caractères spéciaux';

  @override
  String get passwordRequired => 'Le mot de passe est requis';

  @override
  String get passwordTooShort =>
      'Le mot de passe doit comporter au moins 8 caractères';

  @override
  String get passwordLeastOneLetter =>
      'Le mot de passe doit contenir au moins une lettre';

  @override
  String get passwordLeastOneDigit =>
      'Le mot de passe doit contenir au moins un chiffre';

  @override
  String get passwordNoSpaces =>
      'Le mot de passe ne doit pas contenir d\'espaces';

  @override
  String get confirmationRequired => 'La confirmation est requise';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get emailRequired => 'Le courriel est requis';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get signInToContinue => 'Connectez-vous pour continuer';

  @override
  String get usernameOrEmail => 'Nom d\'utilisateur ou Courriel';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get email => 'Courriel';

  @override
  String get password => 'Mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get noAccount => 'Vous n\'avez pas de compte ? ';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get invalidCredentials =>
      'Nom d\'utilisateur ou mot de passe invalide';

  @override
  String get emailAlreadyInUse => 'Ce courriel est déjà utilisé';

  @override
  String get userNotFound => 'Utilisateur introuvable';

  @override
  String get networkError => 'Problème de connexion réseau';

  @override
  String get serverError => 'Erreur du serveur';

  @override
  String get unknownError => 'Une erreur inconnue est survenue';
}

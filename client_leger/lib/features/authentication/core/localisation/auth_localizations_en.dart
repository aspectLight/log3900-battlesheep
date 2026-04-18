// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'auth_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AuthLocalizationsEn extends AuthLocalizations {
  AuthLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get back => 'Back';

  @override
  String get signIn => 'Sign In';

  @override
  String get signingIn => 'Signing In...';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signingUp => 'Creating Account...';

  @override
  String get createAccount => 'Create Account';

  @override
  String get username => 'Username';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get usernamePlaceholder => 'JohnDoe';

  @override
  String get emailPlaceholder => 'johndoe@example.com';

  @override
  String get passwordPlaceholder => '••••••••';

  @override
  String get noAccount => 'Don\'t have an account? ';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get usernameRequired => 'Required field';

  @override
  String get usernameTooShort => 'Username must be at least 3 characters';

  @override
  String get usernameTooLong => 'Username must be at most 15 characters';

  @override
  String get usernameSpecialChars => 'Special characters not allowed';

  @override
  String get usernameInvalidLength =>
      'Username must be between 3 and 15 characters';

  @override
  String get identifierRequired => 'Username or Email is required';

  @override
  String get emailRequired => 'Required field';

  @override
  String get invalidEmail => 'Invalid email format';

  @override
  String get passwordRequired => 'Required field';

  @override
  String get passwordTooShort => 'Minimum 8 characters';

  @override
  String get passwordLeastOneLetter =>
      'Password must contain at least one letter';

  @override
  String get passwordLeastOneDigit =>
      'Password must contain at least one digit';

  @override
  String get passwordNoSpaces => 'Password must not contain spaces';

  @override
  String get confirmationRequired => 'Required field';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get avatarTitle => 'Avatar';

  @override
  String get avatarRequired => 'Select an avatar';

  @override
  String get avatarUploadLabel => 'Upload photo';

  @override
  String get avatarCameraLabel => 'Take photo';

  @override
  String get avatarCustomHint => 'Or choose a custom avatar';

  @override
  String get avatarFileTooLarge => 'Image must be under 4 MB.';

  @override
  String get avatarInvalidFileType => 'Only JPG and PNG images are accepted.';

  @override
  String get avatarUploadFallbackWarning =>
      'Avatar upload failed. The default avatar was kept.';

  @override
  String get invalidCredentials => 'Incorrect username or password';

  @override
  String get emailAlreadyInUse => 'This email is already in use';

  @override
  String get usernameAlreadyInUse => 'This username is already in use';

  @override
  String get accountAlreadyConnected =>
      'This account is already connected on another device.';

  @override
  String get userNotFound => 'No account exists with this identifier';

  @override
  String get networkError => 'Network connection problem';

  @override
  String get serverError => 'Server error';

  @override
  String get unknownError => 'An unknown error occurred';

  @override
  String get teamName => 'Team 105';

  @override
  String get teamMembers =>
      'Ahmed Sami Benabbou, May Guessous, Ayoub Marfouk, Pierre Carré, Anis Gadouche, Djihed Benaiche';
}

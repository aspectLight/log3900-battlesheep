import '../localisation/profile_localizations.dart';

import '../exceptions/profile_failure.dart';

extension ProfileFailureExt on ProfileFailure {
  String localize(ProfileLocalizations l10n) {
    if (this is NetworkProfileFailure) {
      return l10n.profileFillAllFieldsError;
    }
    if (this is UnauthorizedProfileFailure) {
      return l10n.profileFillAllFieldsError;
    }
    if (this is ValidationProfileFailure) {
      return l10n.profileFillAllFieldsError;
    }
    return l10n.profileFillAllFieldsError;
  }
}


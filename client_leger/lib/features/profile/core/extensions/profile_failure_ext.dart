import '../localisation/profile_localizations.dart';

import '../exceptions/profile_failure.dart';

extension ProfileFailureExt on ProfileFailure {
  String localize(ProfileLocalizations l10n) {
    return switch (this) {
      NetworkProfileFailure() => l10n.profileNetworkError,
      BadRequestProfileFailure() => l10n.profileInvalidDataError,
      ForbiddenProfileFailure() => l10n.profileForbiddenError,
      NotFoundProfileFailure() => l10n.profileNotFoundError,
      UnauthorizedProfileFailure() => l10n.profileUnauthorizedError,
      UsernameAlreadyInUseProfileFailure() => l10n.profileUsernameTaken,
      EmailAlreadyInUseProfileFailure() => l10n.profileEmailTaken,
      NoChangesProfileFailure() => l10n.profileNoChanges,
      AvatarFileTooLargeProfileFailure() => l10n.profileAvatarFileTooLarge,
      AvatarInvalidFileTypeProfileFailure() =>
        l10n.profileAvatarInvalidFileType,
      ServerProfileFailure() => l10n.profileServerError,
      UnknownProfileFailure() => l10n.profileUnexpectedError,
    };
  }
}

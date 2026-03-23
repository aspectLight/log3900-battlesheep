import '../exceptions/socket_exception.dart';
import '../localisation/core_localizations.dart';

extension SocketExceptionExt on SocketException {
  String localize(CoreLocalizations l10n) {
    if (this is NotConnectedException) {
      return l10n.networkError;
    }
    if (this is ConnectionFailedException) {
      return l10n.networkError;
    }
    if (this is SocketTimeoutException) {
      return l10n.networkError;
    }
    if (this is UnknownSocketException) {
      return l10n.unknownError;
    }
    return l10n.unknownError;
  }
}

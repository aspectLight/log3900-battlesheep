import 'dart:io' show Platform;

/// Best-effort OS locale string (e.g. `en_US`); null if unavailable.
String? platformLocaleNameFromOs() {
  try {
    final name = Platform.localeName;
    if (name.isEmpty) return null;
    return name;
  } on Object {
    return null;
  }
}

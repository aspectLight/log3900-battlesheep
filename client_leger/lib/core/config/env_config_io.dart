// Desktop (dart:io): reads DEV_INSTANCE from OS env only. Set before flutter run
// (e.g. $env:DEV_INSTANCE = "2") so both instances compile identically and avoid reinstall conflict.
import 'dart:io';

int getDevInstance() {
  final fromOs = Platform.environment['DEV_INSTANCE'];
  if (fromOs != null && fromOs.isNotEmpty) {
    final n = int.tryParse(fromOs);
    if (n != null) return n;
  }
  return 1;
}

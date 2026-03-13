// Dev vs prod: set at build time via --dart-define=FLAVOR=dev (or prod).
class AppFlavor {
  AppFlavor._();

  static const String _devFlavor = 'dev';

  static bool get isDev =>
      const String.fromEnvironment('FLAVOR', defaultValue: 'prod') == _devFlavor; // ignore: do_not_use_environment
}

import 'package:signals_flutter/signals_flutter.dart';

class AppInitialization {
  final Signal<bool> isReady = signal(false);

  void setReady() {
    isReady.value = true;
  }
}

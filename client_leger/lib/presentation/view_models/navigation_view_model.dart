import 'package:signals_flutter/signals_flutter.dart';

class NavigationViewModel {
  final isNavigating = signal<bool>(false);

  void startNavigation() {
    isNavigating.value = true;
  }

  void stopNavigation() {
    Future.delayed(const Duration(milliseconds: 800), () {
      isNavigating.value = false;
    });
  }
}

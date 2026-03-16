import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'modal_coordinator.dart';
import 'modal_widget_registry.dart';

class ModalOverlay extends StatelessWidget {
  const ModalOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final coordinator = GetIt.I<ModalCoordinator>();
    final registry = GetIt.I<ModalWidgetRegistry>();
    return Watch((context) {
      final entry = coordinator.current.value;
      if (entry == null) return const SizedBox.shrink();
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => coordinator.remove(entry.id),
              child: const ColoredBox(
                color: Colors.black54,
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: registry.build(
                  context,
                  entry,
                  () => coordinator.remove(entry.id),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

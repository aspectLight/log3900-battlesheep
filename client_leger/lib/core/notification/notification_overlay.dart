import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'notification_coordinator.dart';
import 'notification_widget_registry.dart';

class NotificationOverlay extends StatelessWidget {
  const NotificationOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final coordinator = GetIt.I<NotificationCoordinator>();
    final registry = GetIt.I<NotificationWidgetRegistry>();
    return Watch((context) {
      final entries = coordinator.entries.value;
      if (entries.isEmpty) return const SizedBox.shrink();
      return Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(color: Colors.black.withValues(alpha: 0.7)),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  for (final entry in entries)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                textSelectionTheme:
                                    const TextSelectionThemeData(
                                      selectionColor: Colors.transparent,
                                      cursorColor: Colors.transparent,
                                    ),
                              ),
                              child: registry.build(context, entry, () {
                                coordinator.remove(entry.id);
                                entry.intent.onDismissAction?.call();
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

import 'package:flutter/material.dart';

import '../../../core/modal/profile_modal_intents.dart';

class ProfilePopupModalContent extends StatelessWidget {
  const ProfilePopupModalContent({
    super.key,
    required this.intent,
    required this.onClose,
  });

  final ProfilePopupModalIntent intent;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final titleColor = intent.isError
        ? const Color(0xFFDC3545)
        : scheme.primary;
    final panelBg = scheme.surface;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: panelBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: intent.isError
                    ? const Color(0xFFDC3545)
                    : scheme.primary,
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 30,
                  offset: Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  intent.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    letterSpacing: 0.5,
                    fontFamily: 'CustomFont',
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  intent.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFF5E6E6),
                    fontSize: 16,
                    fontFamily: 'CustomFont',
                    height: 1.5,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _ModalActionButton(
                      label: intent.primaryLabel,
                      isDestructive: false,
                      onTap: () {
                        intent.onPrimaryAction();
                        onClose();
                      },
                    ),
                    if (intent.secondaryLabel != null &&
                        intent.onSecondaryAction != null)
                      _ModalActionButton(
                        label: intent.secondaryLabel!,
                        isDestructive: true,
                        onTap: () {
                          intent.onSecondaryAction!();
                          onClose();
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModalActionButton extends StatelessWidget {
  const _ModalActionButton({
    required this.label,
    required this.isDestructive,
    required this.onTap,
  });

  final String label;
  final bool isDestructive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDestructive ? const Color(0xFF8B0000) : const Color(0xFF550000),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDestructive
                  ? const Color(0xFFDC3545)
                  : const Color(0xFF7F1F1F),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33550000),
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFFFF0F0),
              fontWeight: FontWeight.w500,
              fontSize: 15,
              letterSpacing: 0.5,
              fontFamily: 'CustomFont',
            ),
          ),
        ),
      ),
    );
  }
}

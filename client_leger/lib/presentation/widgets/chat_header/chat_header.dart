import 'package:flutter/material.dart';

import '../../../generated/l10n/app_localizations.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF2A0E0E),
        border: Border(bottom: BorderSide(color: Color(0xFF3A1212))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.chat,
            style: const TextStyle(
              color: Color(0xFFE0E0FF),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFont',
            ),
          ),
        ],
      ),
    );
  }
}

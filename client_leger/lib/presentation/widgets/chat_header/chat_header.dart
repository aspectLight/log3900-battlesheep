import 'package:flutter/material.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../sliding_chat_box/sliding_chat_box_view_model.dart';

class ChatHeader extends StatelessWidget {
  final ChatTab activeTab;
  final void Function(ChatTab) onTabChange;

  const ChatHeader({
    required this.activeTab,
    required this.onTabChange,
    super.key,
  });

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
            activeTab == ChatTab.chat ? l10n.chat : l10n.journal,
            style: const TextStyle(
              color: Color(0xFFE0E0FF),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFont',
            ),
          ),
          GestureDetector(
            onTap: () => onTabChange(
              activeTab == ChatTab.chat ? ChatTab.journal : ChatTab.chat,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                activeTab == ChatTab.chat ? '⊷' : '⊶',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

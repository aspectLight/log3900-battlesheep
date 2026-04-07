import 'package:flutter/material.dart';

import '../../../../../core/localisation/core_localizations.dart';
import '../../../../core/appearance/app_interaction_colors.dart';
import '../screens/friends_view_model.dart';

const _kHeaderText = Color(0xFFe0d8c0);

class FriendsTabBar extends StatelessWidget {
  const FriendsTabBar({
    super.key,
    required this.activeTab,
    required this.pendingCount,
    required this.friendsCount,
    required this.onTab,
  });

  final FriendsTab activeTab;
  final int pendingCount;
  final int friendsCount;
  final void Function(FriendsTab) onTab;

  @override
  Widget build(BuildContext context) {
    final l10n = CoreLocalizations.of(context)!;
    return Row(
      children: [
        _Tab(
          label: '${l10n.friends} ($friendsCount)',
          tab: FriendsTab.friends,
          activeTab: activeTab,
          onTab: onTab,
        ),
        _Tab(
          label: l10n.demands,
          tab: FriendsTab.requests,
          activeTab: activeTab,
          onTab: onTab,
          badge: pendingCount,
        ),
        _Tab(
          label: l10n.search,
          tab: FriendsTab.search,
          activeTab: activeTab,
          onTab: onTab,
        ),
        _Tab(
          label: l10n.blocked,
          tab: FriendsTab.blocked,
          activeTab: activeTab,
          onTab: onTab,
        ),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.tab,
    required this.activeTab,
    required this.onTab,
    this.badge = 0,
  });

  final String label;
  final FriendsTab tab;
  final FriendsTab activeTab;
  final void Function(FriendsTab) onTab;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final isActive = tab == activeTab;
    return GestureDetector(
      onTap: () => onTab(tab),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          border: Border.all(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : context.interactionColors.outline,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : _kHeaderText,
                fontFamily: 'CustomFont',
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (badge > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$badge',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

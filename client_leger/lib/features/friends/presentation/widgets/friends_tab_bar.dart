import 'package:flutter/material.dart';

import '../screens/friends_view_model.dart';

const _kActive = Color(0xFF8b0000);
const _kBorder = Color(0xFF3a3a3a);
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
    return Row(
      children: [
        _Tab(
          label: 'Amis ($friendsCount)',
          tab: FriendsTab.friends,
          activeTab: activeTab,
          onTab: onTab,
        ),
        _Tab(
          label: 'Demandes',
          tab: FriendsTab.requests,
          activeTab: activeTab,
          onTab: onTab,
          badge: pendingCount,
        ),
        _Tab(
          label: 'Rechercher',
          tab: FriendsTab.search,
          activeTab: activeTab,
          onTab: onTab,
        ),
        _Tab(
          label: 'Bloqués',
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
          color: isActive ? _kActive : Colors.transparent,
          border: Border.all(color: isActive ? _kActive : _kBorder),
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

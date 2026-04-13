import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_interaction_colors.dart';
import '../../../../../core/localisation/core_localizations.dart';
import '../../../../../core/presentation/widgets/app_background/app_background.dart';
import '../widgets/friends_tab_bar.dart';
import '../widgets/user_card.dart';
import 'friends_view_model.dart';

const _kBorder = Color(0xFF3a3a3a);
const _kHeaderText = Color(0xFFe0d8c0);
const _kStateBg = Color(0x40000000);
const _kAccept = Color(0xFF145214);
const _kBlock = Color(0xFFffb347);
const _kBlockBorder = Color(0xFF8b5a00);

@RoutePage()
class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  late final FriendsViewModel _viewModel;
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<FriendsViewModel>();
    unawaited(_viewModel.loadAll());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => _viewModel.searchUsers(query),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = CoreLocalizations.of(context)!;
    return AppBackground(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeader(l10n),
            const SizedBox(height: 12),
            Watch((context) {
              final err = _viewModel.errorMessage.value;
              if (err == null) return const SizedBox.shrink();
              return _buildErrorBanner(err);
            }),
            Watch(
              (context) => FriendsTabBar(
                activeTab: _viewModel.activeTab.value,
                pendingCount: _viewModel.pendingRequests.value.length,
                friendsCount: _viewModel.friends.value.length,
                onTab: _viewModel.setTab,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: Watch((context) => _buildTabContent(l10n))),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(CoreLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: _viewModel.requestLeave,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 18),
                    Text(
                      l10n.homePage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'CustomFont',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Text(
            l10n.friends,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 44,
              fontFamily: 'CustomFont',
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              shadows: [
                Shadow(
                  color: Color(0x99000000),
                  offset: Offset(0, 3),
                  blurRadius: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0x26C83232),
        border: Border.all(color: const Color(0xFF7f1f1f)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Color(0xFFff9090),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTabContent(CoreLocalizations l10n) {
    if (_viewModel.isLoading.value) return _buildState(l10n.loading);
    return switch (_viewModel.activeTab.value) {
      FriendsTab.friends => _buildFriendsList(l10n),
      FriendsTab.requests => _buildRequestsList(l10n),
      FriendsTab.search => _buildSearchTab(l10n),
      FriendsTab.blocked => _buildBlockedList(l10n),
    };
  }

  Widget _buildFriendsList(CoreLocalizations l10n) {
    final list = _viewModel.friends.value;
    if (list.isEmpty) return _buildState(l10n.noFriends);
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, i) {
        final f = list[i];
        return UserCard(
          username: f.username,
          avatarId: f.avatarId,
          isOnline: f.isOnline,
          actions: [
            FriendActionButton(
              label: l10n.removeFriend,
              onPressed: () => _viewModel.removeFriend(f.username),
            ),
            FriendActionButton(
              label: l10n.blockUser,
              onPressed: () => _viewModel.blockUser(f.username),
              color: _kBlock,
              borderColor: _kBlockBorder,
            ),
          ],
        );
      },
    );
  }

  Widget _buildRequestsList(CoreLocalizations l10n) {
    final pending = _viewModel.pendingRequests.value;
    final sent = _viewModel.sentRequests.value;
    if (pending.isEmpty && sent.isEmpty) return _buildState(l10n.noRequests);
    return ListView(
      children: [
        if (pending.isNotEmpty) ...[
          _buildSectionTitle(l10n.receivedRequests),
          ...pending.map(
            (r) => UserCard(
              username: r.senderId,
              actions: [
                FriendActionButton(
                  label: l10n.accept,
                  onPressed: () => _viewModel.acceptRequest(r.id),
                  color: Colors.white,
                  bg: _kAccept,
                  borderColor: _kAccept,
                ),
                FriendActionButton(
                  label: l10n.refuse,
                  onPressed: () => _viewModel.refuseRequest(r.id),
                ),
              ],
            ),
          ),
        ],
        if (sent.isNotEmpty) ...[
          _buildSectionTitle(l10n.sentRequests),
          ...sent.map(
            (r) => UserCard(
              username: r.receiverId,
              actions: [
                FriendActionButton(
                  label: l10n.cancel,
                  onPressed: () => _viewModel.cancelRequest(r.id),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSearchTab(CoreLocalizations l10n) {
    final results = _viewModel.searchResults.value;
    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          style: const TextStyle(color: Color(0xFFF0F0F0)),
          decoration: InputDecoration(
            hintText: l10n.searchUser,
            hintStyle: const TextStyle(color: Color(0xFF666666)),
            filled: true,
            fillColor: const Color(0x66000000),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: context.interactionColors.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: context.interactionColors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: context.interactionColors.outline),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (_searchController.text.isNotEmpty && results.isEmpty)
          _buildState(l10n.noResults)
        else
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (_, i) {
                final u = results[i];
                final isBlocked = _viewModel.isBlocked(u.username);
                final hasPending = _viewModel.hasPendingRequestTo(u.username);
                return UserCard(
                  username: u.username,
                  avatarId: u.avatarId,
                  isOnline: u.isOnline,
                  actions: isBlocked
                      ? [
                          FriendActionButton(
                            label: l10n.unblockUser,
                            onPressed: () => _viewModel.unblockUser(u.username),
                            color: Colors.white,
                            bg: _kAccept,
                            borderColor: _kAccept,
                          ),
                        ]
                      : [
                          if (hasPending)
                            FriendActionButton(
                              label: l10n.cancel,
                              onPressed: () => _viewModel
                                  .cancelRequestByUsername(u.username),
                            )
                          else
                            FriendActionButton(
                              label: l10n.addFriend,
                              onPressed: () =>
                                  _viewModel.sendRequest(u.username),
                              color: Colors.white,
                              bg: _kAccept,
                              borderColor: _kAccept,
                            ),
                          FriendActionButton(
                            label: l10n.blockUser,
                            onPressed: () =>
                                _viewModel.blockUserFromSearch(u.username),
                            color: _kBlock,
                            borderColor: _kBlockBorder,
                          ),
                        ],
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBlockedList(CoreLocalizations l10n) {
    final list = _viewModel.blockedUsers.value;
    if (list.isEmpty) return _buildState(l10n.noBlockedUsers);
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, i) => UserCard(
        username: list[i],
        actions: [
          FriendActionButton(
            label: l10n.unblockUser,
            onPressed: () => _viewModel.unblockUser(list[i]),
            color: Colors.white,
            bg: _kAccept,
            borderColor: _kAccept,
          ),
        ],
      ),
    );
  }

  Widget _buildState(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _kStateBg,
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: _kHeaderText,
          fontFamily: 'CustomFont',
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: _kHeaderText,
          fontFamily: 'CustomFont',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

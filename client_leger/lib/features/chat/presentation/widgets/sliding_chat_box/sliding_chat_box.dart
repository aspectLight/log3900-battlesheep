import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_interaction_colors.dart';
import '../../../../../core/presentation/widgets/profile_avatar_thumb/profile_avatar_thumb.dart';
import '../../../core/constants/chat_constants.dart';
import '../../../core/event_bus/chat_event_bus.dart';
import '../../../core/localisation/chat_localizations.dart';
import '../../../data/models/channel_info.dart';
import '../chat_panel_content/chat_panel_content.dart';
import '../chat_panel_content/chat_panel_content_view_model.dart';
import 'sliding_chat_box_view_model.dart';

class SlidingChatBox extends StatefulWidget {
  const SlidingChatBox({
    super.key,
    required this.viewModel,
    required this.chatPanelContentViewModel,
    required this.chatEventBus,
  });

  final SlidingChatBoxViewModel viewModel;
  final ChatPanelContentViewModel chatPanelContentViewModel;
  final ChatEventBus chatEventBus;

  @override
  State<SlidingChatBox> createState() => _SlidingChatBoxState();
}

class _SlidingChatBoxState extends State<SlidingChatBox> {
  @override
  Widget build(BuildContext context) {
    final isExpanded = widget.viewModel.isExpanded.watch(context);
    final width = (MediaQuery.of(context).size.width * 0.35).clamp(
      400.0,
      double.infinity,
    );
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // ── Backdrop ───────────────────────────────────────────────
          IgnorePointer(
            ignoring: !isExpanded,
            child: GestureDetector(
              onTap: widget.viewModel.toggleExpanded,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                color: isExpanded
                    ? Colors.black.withValues(alpha: 0.5)
                    : Colors.transparent,
              ),
            ),
          ),

          // ── Sliding panel ──────────────────────────────────────────
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: 100,
            bottom: 100 + keyboardHeight,
            left: isExpanded ? 0 : -width,
            width: width,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.interactionColors.primary.withValues(alpha: 0.9),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                border: Border.all(
                  color: context.interactionColors.primary,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
                child: Column(
                  children: [
                    _ChatHeader(viewModel: widget.viewModel),
                    Watch((context) {
                      final isPanelOpen =
                          widget.viewModel.showChannelsPanel.value;

                      // ── Channels panel overlay ─────────────────────
                      if (isPanelOpen) {
                        return Expanded(
                          child: _ChannelsPanelView(
                            viewModel: widget.viewModel,
                          ),
                        );
                      }

                      // ── Regular chat content ───────────────────────
                      final activeId = widget.viewModel.activeChannelId.value;
                      if (activeId == null) {
                        return ChatPanelContent(
                          viewModel: widget.chatPanelContentViewModel,
                          chatEventBus: widget.chatEventBus,
                        );
                      }
                      return _ChannelChatPanel(
                        viewModel: widget.viewModel,
                        channelId: activeId,
                        emojis: widget.chatPanelContentViewModel.defaultEmojis,
                        selectedEmojiIndex: widget
                            .chatPanelContentViewModel
                            .selectedEmojiIndex
                            .value,
                        onSelectEmoji:
                            widget.chatPanelContentViewModel.selectEmoji,
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          // ── Toggle button ──────────────────────────────────────────
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: isExpanded ? width - 10.0 : -10.0,
            top: screenHeight / 2.0 - 24.0 - (keyboardHeight / 2),
            child: GestureDetector(
              onTap: widget.viewModel.toggleExpanded,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: context.interactionColors.primary,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  border: Border.all(
                    color: context.interactionColors.outline,
                    width: 2,
                  ),
                ),
                child: const Icon(Icons.chat_bubble, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chat header with tabs + channels panel button ──────────────────────────

class _ChatHeader extends StatefulWidget {
  const _ChatHeader({required this.viewModel});

  final SlidingChatBoxViewModel viewModel;

  @override
  State<_ChatHeader> createState() => _ChatHeaderState();
}

class _ChatHeaderState extends State<_ChatHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: context.interactionColors.primary,
        border: Border(
          bottom: BorderSide(color: context.interactionColors.primaryStrong),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            child: _ChannelDropdown(viewModel: widget.viewModel),
          ),
          GestureDetector(
            onTap: widget.viewModel.toggleChannelsPanel,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: context.interactionColors.primaryStrong,
                ),
              ),
              child: const Icon(Icons.menu, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Channel dropdown widget ────────────────────────────────────────────────

class _ChannelDropdown extends StatelessWidget {
  const _ChannelDropdown({required this.viewModel});

  final SlidingChatBoxViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = ChatLocalizations.of(context)!;

    return Watch((context) {
      final joinedIds = viewModel.joinedChannelIds.value;
      final activeId = viewModel.activeChannelId.value;
      final isPanelOpen = viewModel.showChannelsPanel.value;
      final String selectedChannel = activeId ?? 'general';
      final List<DropdownMenuItem<String>> options = [
        DropdownMenuItem(
          value: 'general',
          child: Text(
            l10n.chatGeneralTab,
            style: const TextStyle(fontFamily: 'CustomFont'),
          ),
        ),
        ...joinedIds.map(
          (id) => DropdownMenuItem(
            value: id,
            child: Text(
              '#${viewModel.resolveChannelName(id)}',
              style: const TextStyle(fontFamily: 'CustomFont'),
            ),
          ),
        ),
      ];

      return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedChannel,
          items: options,
          dropdownColor: context.interactionColors.primary,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          onChanged: (value) {
            if (value == null) return;
            if (value == 'general') {
              if (isPanelOpen) viewModel.toggleChannelsPanel();
              viewModel.setActiveChannel(null);
            } else {
              viewModel.setActiveChannel(value);
            }
          },
        ),
      );
    });
  }
}

// ── Channels panel ─────────────────────────────────────────────────────────

class _ChannelsPanelView extends StatefulWidget {
  const _ChannelsPanelView({required this.viewModel});

  final SlidingChatBoxViewModel viewModel;

  @override
  State<_ChannelsPanelView> createState() => _ChannelsPanelViewState();
}

class _ChannelsPanelViewState extends State<_ChannelsPanelView> {
  final _createController = TextEditingController();
  final _searchController = TextEditingController();
  String _filterTerm = '';

  @override
  void dispose() {
    _createController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _submitCreate() {
    widget.viewModel.createChannel(_createController.text);
    _createController.clear();
  }

  List<ChannelInfo> _filtered(List<ChannelInfo> all) {
    final term = _filterTerm.trim().toLowerCase();
    if (term.isEmpty) return all;
    return all.where((c) => c.name.toLowerCase().contains(term)).toList();
  }

  Future<void> _requestDelete(String channelId, ChatLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          l10n.confirmDeleteChannel,
          style: TextStyle(
            color: context.interactionColors.primary,
            fontFamily: 'CustomFont',
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: TextButton.styleFrom(
              backgroundColor: context.interactionColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              l10n.no,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'CustomFont',
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              backgroundColor: context.interactionColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              l10n.yes,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'CustomFont',
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed ?? false) widget.viewModel.deleteChannel(channelId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ChatLocalizations.of(context)!;
    return ColoredBox(
      color: context.interactionColors.primary,
      child: Column(
        children: [
          _buildPanelHeader(l10n),
          Watch((context) => _buildAlerts()),
          Expanded(
            child: Watch((context) {
              final allChannels = widget.viewModel.channels.value;
              final isLoading = widget.viewModel.isChannelsLoading.value;
              // Track joined changes so rows update on join/leave.
              widget.viewModel.joinedChannelIds.value;
              final filtered = _filtered(allChannels);
              return SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCreateSection(l10n),
                    const SizedBox(height: 12),
                    _buildAvailableChannels(filtered, isLoading, l10n),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── Panel header ──────────────────────────────────────────────────

  Widget _buildPanelHeader(ChatLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border(
          bottom: BorderSide(color: context.interactionColors.outline),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.discussionCanals.toUpperCase(),
            style: TextStyle(
              color: context.interactionColors.text,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFont',
            ),
          ),
        ],
      ),
    );
  }

  // ── Alerts ────────────────────────────────────────────────────────

  Widget _buildAlerts() {
    final success = widget.viewModel.channelSuccessMessage.value;
    final error = widget.viewModel.channelErrorMessage.value;
    if (success == null && error == null) return const SizedBox.shrink();
    return Column(
      children: [
        if (success != null) _buildAlert(success, isSuccess: true),
        if (error != null) _buildAlert(error, isSuccess: false),
      ],
    );
  }

  Widget _buildAlert(String message, {required bool isSuccess}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSuccess ? const Color(0x2632B464) : const Color(0x26C83232),
        border: Border.all(
          color: isSuccess ? const Color(0xFF2e7d52) : const Color(0xFF7f1f1f),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isSuccess ? const Color(0xFFa8f0c8) : const Color(0xFFff9090),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          fontFamily: 'CustomFont',
        ),
      ),
    );
  }

  // ── Create channel section ────────────────────────────────────────

  Widget _buildCreateSection(ChatLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.interactionColors.primary,
        border: Border.all(color: context.interactionColors.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.createChannel,
            style: TextStyle(
              color: context.interactionColors.text,
              fontSize: 12,
              fontFamily: 'CustomFont',
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _StyledTextField(
                  controller: _createController,
                  hint: l10n.channelNameHint,
                  maxLength: 50,
                  onSubmitted: (_) => _submitCreate(),
                ),
              ),
              const SizedBox(width: 8),
              _PanelButton(
                label: l10n.create,
                textColor: Colors.white,
                backgroundColor: context.interactionColors.primary,
                borderColor: context.interactionColors.outline,
                onPressed: _submitCreate,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Available channels section ────────────────────────────────────

  Widget _buildAvailableChannels(
    List<ChannelInfo> filtered,
    bool isLoading,
    ChatLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.interactionColors.primary,
        border: Border.all(color: context.interactionColors.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.availableChannels,
            style: TextStyle(
              color: context.interactionColors.text,
              fontSize: 12,
              fontFamily: 'CustomFont',
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          _StyledTextField(
            controller: _searchController,
            hint: l10n.searchChannelsHint,
            onChanged: (v) => setState(() => _filterTerm = v),
          ),
          const SizedBox(height: 8),
          if (isLoading)
            _buildStateBox(l10n.loadingChannels)
          else if (filtered.isEmpty)
            _buildStateBox(l10n.noChannelsFound)
          else
            _buildChannelTable(filtered, l10n),
        ],
      ),
    );
  }

  Widget _buildChannelTable(
    List<ChannelInfo> channels,
    ChatLocalizations l10n,
  ) {
    return Column(
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: context.interactionColors.outline,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            border: Border(
              left: BorderSide(color: context.interactionColors.outline),
              right: BorderSide(color: context.interactionColors.outline),
              top: BorderSide(color: context.interactionColors.outline),
            ),
          ),
          child: Row(
            children: [
              Expanded(flex: 2, child: _TableHeaderCell(l10n.channelName)),
              Expanded(flex: 2, child: _TableHeaderCell(l10n.channelCreator)),
              Expanded(
                flex: 2,
                child: _TableHeaderCell(
                  l10n.channelActions,
                  align: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        // Table rows
        ...channels.asMap().entries.map(
          (e) => _buildChannelRow(
            e.value,
            l10n,
            isLast: e.key == channels.length - 1,
          ),
        ),
      ],
    );
  }

  Widget _buildChannelRow(
    ChannelInfo channel,
    ChatLocalizations l10n, {
    required bool isLast,
  }) {
    final joined = widget.viewModel.isJoined(channel.id);
    final creator = widget.viewModel.isCreator(channel);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.interactionColors.primary,
        border: Border(
          left: BorderSide(
            color: context.interactionColors.outline,
            width: creator ? 3 : 1,
          ),
          right: BorderSide(color: context.interactionColors.outline),
          bottom: BorderSide(color: context.interactionColors.outline),
        ),
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(6))
            : null,
      ),
      child: Row(
        children: [
          // Channel name + creator badge
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    channel.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'CustomFont',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (creator) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: context.interactionColors.primary,
                      border: Border.all(
                        color: context.interactionColors.outline,
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n.creatorBadge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'CustomFont',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Creator name
          Expanded(
            flex: 2,
            child: Text(
              channel.creator,
              style: const TextStyle(
                color: Color(0xFFb0b0b0),
                fontSize: 12,
                fontFamily: 'CustomFont',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Action buttons
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (joined)
                  _PanelButton(
                    label: l10n.leaveChannel,
                    textColor: const Color(0xFFffb347),
                    borderColor: const Color(0xFF8b5a00),
                    onPressed: () => widget.viewModel.leaveChannel(channel.id),
                  )
                else
                  _PanelButton(
                    label: l10n.joinChannel,
                    textColor: Colors.white,
                    backgroundColor: const Color(0xFF145214),
                    onPressed: () => widget.viewModel.joinChannel(channel.id),
                  ),
                if (creator) ...[
                  const SizedBox(width: 4),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 100,
                    ), // Limite la largeur
                    child: _PanelButton(
                      label: l10n.deleteChannel,
                      textColor: Colors.white,
                      borderColor: const Color(0xFF7f1f1f),
                      backgroundColor: const Color(0xFF7f1f1f),
                      onPressed: () => _requestDelete(channel.id, l10n),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x40000000),
        border: Border.all(color: const Color(0xFF3a3a3a)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'CustomFont',
          fontSize: 14,
        ),
      ),
    );
  }
}

// ── Reusable panel widgets ─────────────────────────────────────────────────

class _StyledTextField extends StatelessWidget {
  const _StyledTextField({
    required this.controller,
    required this.hint,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: const TextStyle(
        color: Color(0xFFF0F0F0),
        fontSize: 13,
        fontFamily: 'CustomFont',
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF666666),
          fontSize: 13,
          fontFamily: 'CustomFont',
        ),
        counterText: '',
        filled: true,
        fillColor: const Color(0x66000000),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: context.interactionColors.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
    );
  }
}

class _PanelButton extends StatelessWidget {
  const _PanelButton({
    required this.label,
    required this.textColor,
    required this.onPressed,
    this.backgroundColor,
    this.borderColor,
  });

  final String label;
  final Color textColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: backgroundColor ?? Colors.transparent,
        side: borderColor != null
            ? BorderSide(color: borderColor!)
            : BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(60, 35),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        textStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFamily: 'CustomFont',
        ),
      ),
      child: Text(label, style: TextStyle(color: textColor)),
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  const _TableHeaderCell(this.text, {this.align = TextAlign.left});

  final String text;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: context.interactionColors.text,
        fontFamily: 'CustomFont',
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
        fontSize: 12,
      ),
    );
  }
}

// ── Channel-specific chat panel ───────────────────────────────────────────

class _ChannelChatPanel extends StatefulWidget {
  const _ChannelChatPanel({
    required this.viewModel,
    required this.channelId,
    required this.emojis,
    required this.selectedEmojiIndex,
    required this.onSelectEmoji,
  });

  final SlidingChatBoxViewModel viewModel;
  final String channelId;
  final List<String> emojis;
  final int selectedEmojiIndex;
  final void Function(int) onSelectEmoji;

  @override
  State<_ChannelChatPanel> createState() => _ChannelChatPanelState();
}

class _ChannelChatPanelState extends State<_ChannelChatPanel> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  void _send() {
    widget.viewModel.sendChannelMessage(_controller.text.trim());
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ChatLocalizations.of(context)!;
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Watch((context) {
              final messages = widget.viewModel.displayChannelMessages.value;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.jumpTo(
                    _scrollController.position.maxScrollExtent,
                  );
                }
              });
              if (messages.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucun message.',
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontFamily: 'CustomFont',
                    ),
                  ),
                );
              }
              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 8),
                itemCount: messages.length,
                itemBuilder: (_, i) {
                  final msg = messages[i];
                  final showAvatar = msg.senderName.trim().isNotEmpty;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: i.isEven
                          ? context.interactionColors.primary
                          : context.interactionColors.primaryStrong,
                      border: Border(
                        bottom: BorderSide(
                          color: context.interactionColors.primaryStrong,
                        ),
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFF0F0F0),
                          fontFamily: 'CustomFont',
                        ),
                        children: [
                          TextSpan(
                            text: '${msg.time} - ',
                            style: const TextStyle(
                              color: Color(0xFFAAAAAA),
                              fontSize: 12,
                            ),
                          ),
                          if (msg.senderName.isNotEmpty)
                            TextSpan(
                              text: msg.senderName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          if (showAvatar)
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: ProfileAvatarThumb(
                                  displayName: msg.senderName,
                                  avatarId: msg.avatarId,
                                  avatarUrl: msg.avatarUrl,
                                  avatarDisplayNonce: msg.avatarDisplayNonce,
                                  size: 18,
                                ),
                              ),
                            ),
                          if (msg.senderName.isNotEmpty)
                            const TextSpan(text: ': '),
                          TextSpan(text: msg.content),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          _buildInput(l10n),
        ],
      ),
    );
  }

  Widget _buildInput(ChatLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.interactionColors.primaryStrong,
        border: Border(
          top: BorderSide(
            color: context.interactionColors.outline.withValues(alpha: 0.65),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF2B2B2B),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF444444)),
              ),
              child: EditableText(
                controller: _controller,
                focusNode: _focusNode,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'CustomFont',
                ),
                cursorColor: context.interactionColors.outline,
                backgroundCursorColor: Colors.grey,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                    ChatConstants.messageMaxLength,
                  ),
                ],
                onSubmitted: (_) => _send(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ...widget.emojis.asMap().entries.map((entry) {
            final isSelected = entry.key == widget.selectedEmojiIndex;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: GestureDetector(
                onTap: () => widget.onSelectEmoji(entry.key),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.interactionColors.primaryStrong
                        : context.interactionColors.primary,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isSelected
                          ? context.interactionColors.outline
                          : const Color(0xFF444444),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _send,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: context.interactionColors.primary,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: context.interactionColors.outline),
              ),
              child: Text(
                l10n.send,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'CustomFont',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/event_bus/chat_event_bus.dart';
import '../../../core/localisation/chat_localizations.dart';
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
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: 100,
            bottom: 100 + keyboardHeight,
            left: isExpanded ? 0 : -width,
            width: width,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF160707).withValues(alpha: 0.9),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                border: Border.all(color: const Color(0xFF3A1212), width: 2),
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
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
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
                  color: const Color(0xFF2A0E0E),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  border: Border.all(color: const Color(0xFF3A1212), width: 2),
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

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.viewModel});

  final SlidingChatBoxViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = ChatLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: const BoxDecoration(
        color: Color(0xFF2A0E0E),
        border: Border(bottom: BorderSide(color: Color(0xFF3A1212))),
      ),
      child: Watch((context) {
        final joinedIds = viewModel.joinedChannelIds.value;
        final activeId = viewModel.activeChannelId.value;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _ChannelTab(
                label: l10n.chatGeneralTab,
                isActive: activeId == null,
                onTap: () => viewModel.setActiveChannel(null),
              ),
              ...joinedIds.map(
                (id) => _ChannelTab(
                  label: '#${viewModel.resolveChannelName(id)}',
                  isActive: activeId == id,
                  onTap: () => viewModel.setActiveChannel(id),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ChannelTab extends StatelessWidget {
  const _ChannelTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF550000) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isActive ? const Color(0xFF7F1F1F) : const Color(0xFF3A1212),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFFE0E0FF) : const Color(0xFF999999),
            fontSize: 13,
            fontFamily: 'CustomFont',
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _ChannelChatPanel extends StatefulWidget {
  const _ChannelChatPanel({required this.viewModel, required this.channelId});

  final SlidingChatBoxViewModel viewModel;
  final String channelId;

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
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Watch((context) {
              final messages = widget.viewModel.activeChannelMessages.value;
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
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: i.isEven
                          ? const Color(0xFF180505)
                          : const Color(0xFF220808),
                      border: const Border(
                        bottom: BorderSide(color: Color(0xFF250808)),
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
                              text: '${msg.senderName}: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          TextSpan(text: msg.content),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF1E0707),
              border: Border(top: BorderSide(color: Color(0xFF3A1212))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B2B2B),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF444444)),
                    ),
                    child: EditableText(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: const TextStyle(
                        color: Color(0xFFF5E6E6),
                        fontSize: 14,
                        fontFamily: 'CustomFont',
                      ),
                      cursorColor: const Color(0xFF7F1F1F),
                      backgroundCursorColor: Colors.grey,
                      inputFormatters: [LengthLimitingTextInputFormatter(200)],
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF550000),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF7F1F1F)),
                    ),
                    child: const Text(
                      'Envoyer',
                      style: TextStyle(
                        color: Color(0xFFF5E6E6),
                        fontSize: 14,
                        fontFamily: 'CustomFont',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

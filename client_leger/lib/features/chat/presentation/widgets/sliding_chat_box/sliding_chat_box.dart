import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_interaction_colors.dart';
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
  late final SlidingChatBoxViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
  }

  @override
  Widget build(BuildContext context) {
    final isExpanded = _viewModel.isExpanded.watch(context);
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
              onTap: _viewModel.toggleExpanded,
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
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.9),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
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
                    const _ChatHeader(),
                    ChatPanelContent(
                      viewModel: widget.chatPanelContentViewModel,
                      chatEventBus: widget.chatEventBus,
                    ),
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
              onTap: _viewModel.toggleExpanded,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
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

class _ChatHeader extends StatelessWidget {
  const _ChatHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = ChatLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            l10n.chat,
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
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

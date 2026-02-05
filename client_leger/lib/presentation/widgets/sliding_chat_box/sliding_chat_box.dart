import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../chat_header/chat_header.dart';
import '../chat_panel_content/chat_panel_content.dart';
import 'sliding_chat_box_view_model.dart';

class SlidingChatBox extends StatefulWidget {
  const SlidingChatBox({super.key});

  @override
  State<SlidingChatBox> createState() => _SlidingChatBoxState();
}

class _SlidingChatBoxState extends State<SlidingChatBox> {
  late final SlidingChatBoxViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<SlidingChatBoxViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    final isExpanded = _viewModel.isExpanded.watch(context);
    final activeTab = _viewModel.activeTab.watch(context);
    final width = MediaQuery.of(context).size.width * 0.35;
    final screenHeight = MediaQuery.of(context).size.height;

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
            bottom: 100,
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
                    ChatHeader(
                      activeTab: activeTab,
                      onTabChange: _viewModel.setTab,
                    ),
                    ChatPanelContent(activeTab: activeTab),
                  ],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: isExpanded ? width - 10.0 : -10.0,
            top: screenHeight / 2.0 - 24.0,
            child: GestureDetector(
              onTap: _viewModel.toggleExpanded,
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
                child: Icon(
                  isExpanded ? Icons.chevron_left : Icons.chevron_right,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

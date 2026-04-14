import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_interaction_colors.dart';
import '../../../../../core/presentation/widgets/profile_avatar_thumb/profile_avatar_thumb.dart';
import '../../../core/constants/chat_constants.dart';
import '../../../core/event_bus/chat_event_bus.dart';
import '../../../core/localisation/chat_localizations.dart';
import '../../ui_models/chat_message_ui.dart';
import 'chat_panel_content_view_model.dart';

class ChatPanelContent extends StatefulWidget {
  const ChatPanelContent({
    super.key,
    required this.viewModel,
    required this.chatEventBus,
  });

  final ChatPanelContentViewModel viewModel;
  final ChatEventBus chatEventBus;

  @override
  State<ChatPanelContent> createState() => _ChatPanelContentState();
}

class _ChatPanelContentState extends State<ChatPanelContent>
    with WidgetsBindingObserver {
  late final ChatPanelContentViewModel _viewModel;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeTime;

  double _previousKeyboardHeight = 0;
  bool _wasAtBottom = true;
  int _previousMessagesLength = 0;
  double _previousListHeight = 0;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    WidgetsBinding.instance.addObserver(this);
    _setupShakeDetection();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    _wasAtBottom = position.pixels >= position.maxScrollExtent - 100;
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    final views = PlatformDispatcher.instance.views;
    final currentKeyboardHeight = views.isNotEmpty
        ? views.first.viewInsets.bottom
        : 0.0;

    if (_previousKeyboardHeight > 0 && currentKeyboardHeight == 0) {
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
    }

    _previousKeyboardHeight = currentKeyboardHeight;
  }

  void _setupShakeDetection() {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    final chatEventBus = widget.chatEventBus;
    _accelerometerSubscription = accelerometerEventStream().listen(
      (event) => _onAccelerometerEvent(event, chatEventBus),
    );
  }

  void _onAccelerometerEvent(
    AccelerometerEvent event,
    ChatEventBus chatEventBus,
  ) {
    final now = DateTime.now();
    if (_lastShakeTime != null &&
        now.difference(_lastShakeTime!).inMilliseconds <
            ChatConstants.shakeCooldownMs) {
      return;
    }
    final isVerticalShake =
        event.y.abs() > ChatConstants.shakeThresholdVertical &&
        event.x.abs() < ChatConstants.shakeDeadZone;
    final isHorizontalShake =
        event.x.abs() > ChatConstants.shakeThresholdHorizontal &&
        event.y.abs() < ChatConstants.shakeDeadZone;
    if (isVerticalShake) {
      _lastShakeTime = now;
      chatEventBus.fire(const ChatVerticalShakeDetected());
    } else if (isHorizontalShake) {
      _lastShakeTime = now;
      chatEventBus.fire(const ChatHorizontalShakeDetected());
    }
  }

  void _onSendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    _viewModel.sendMessage(text);
    _messageController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return _ChatPanelContentView(
      uiMessages: _viewModel.uiMessages,
      selectedEmojiIndex: _viewModel.selectedEmojiIndex,
      emojis: _viewModel.defaultEmojis,
      onSelectEmoji: _viewModel.selectEmoji,
      onSendMessage: _onSendMessage,
      messageController: _messageController,
      focusNode: _focusNode,
      scrollController: _scrollController,
      isAtBottom: () => _wasAtBottom,
      onMessagesChanged: _onMessagesChanged,
      onListLayout: _onListLayout,
    );
  }

  void _onMessagesChanged(int length, {required bool shouldScrollToBottom}) {
    if (!shouldScrollToBottom) {
      _previousMessagesLength = length;
      return;
    }
    if (length <= _previousMessagesLength) {
      _previousMessagesLength = length;
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      unawaited(
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        ),
      );
    });
    _previousMessagesLength = length;
  }

  void _onListLayout(double height) {
    final heightChanged =
        _previousListHeight > 0 && height != _previousListHeight;
    _previousListHeight = height;
    if (heightChanged && _wasAtBottom) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scrollController.hasClients) return;
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_onScroll);
    unawaited(_accelerometerSubscription?.cancel());
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

class _ChatPanelContentView extends StatelessWidget {
  const _ChatPanelContentView({
    required this.uiMessages,
    required this.selectedEmojiIndex,
    required this.emojis,
    required this.onSelectEmoji,
    required this.onSendMessage,
    required this.messageController,
    required this.focusNode,
    required this.scrollController,
    required this.isAtBottom,
    required this.onMessagesChanged,
    required this.onListLayout,
  });

  final Computed<List<ChatMessageUi>> uiMessages;
  final ReadonlySignal<int> selectedEmojiIndex;
  final List<String> emojis;
  final void Function(int) onSelectEmoji;
  final VoidCallback onSendMessage;
  final TextEditingController messageController;
  final FocusNode focusNode;
  final ScrollController scrollController;
  final bool Function() isAtBottom;
  final void Function(int length, {required bool shouldScrollToBottom})
  onMessagesChanged;
  final void Function(double height) onListLayout;

  @override
  Widget build(BuildContext context) {
    final l10n = ChatLocalizations.of(context)!;
    return Watch.builder(
      builder: (context) {
        final messages = uiMessages.value;
        final selectedIndex = selectedEmojiIndex.value;
        if (messages.isNotEmpty) {
          final shouldScrollToBottom = isAtBottom() || messages.last.isMe;
          onMessagesChanged(
            messages.length,
            shouldScrollToBottom: shouldScrollToBottom,
          );
        }
        return Expanded(
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    onListLayout(constraints.maxHeight);
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.only(bottom: 8),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return _ChatLine(
                          key: ValueKey('${message.time}-${message.content}'),
                          message: message,
                          index: index,
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.interactionColors.primaryStrong,
                  border: Border(
                    top: BorderSide(
                      color: context.interactionColors.outline.withValues(
                        alpha: 0.65,
                      ),
                    ),
                  ),
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
                          controller: messageController,
                          focusNode: focusNode,
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
                          onSubmitted: (_) => onSendMessage(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: emojis.asMap().entries.map((entry) {
                        final index = entry.key;
                        final emoji = entry.value;
                        final isSelected = index == selectedIndex;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: GestureDetector(
                            onTap: () => onSelectEmoji(index),
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
                                emoji,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'CustomFont',
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: onSendMessage,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: context.interactionColors.primary,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: context.interactionColors.outline,
                          ),
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
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChatLine extends StatelessWidget {
  final ChatMessageUi message;
  final int index;

  const _ChatLine({super.key, required this.message, required this.index});

  @override
  Widget build(BuildContext context) {
    final showAvatar = message.name.trim().isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: index.isEven
            ? context.interactionColors.primary
            : context.interactionColors.primaryStrong,
        border: Border(
          bottom: BorderSide(color: context.interactionColors.primaryStrong),
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
              text: '${message.time} - ',
              style: const TextStyle(
                color: Color(0xFFAAAAAA),
                fontSize: 12,
                fontFamily: 'CustomFont',
              ),
            ),
            if (message.name.isNotEmpty)
              TextSpan(
                text: message.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'CustomFont',
                ),
              ),
            if (showAvatar)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ProfileAvatarThumb(
                    displayName: message.name,
                    avatarId: message.avatarId,
                    avatarUrl: message.avatarUrl,
                    size: 18,
                  ),
                ),
              ),
            if (message.name.isNotEmpty) const TextSpan(text: ': '),
            TextSpan(
              text: message.content,
              style: const TextStyle(fontFamily: 'CustomFont'),
            ),
          ],
        ),
      ),
    );
  }
}

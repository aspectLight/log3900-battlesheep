import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/constants/chat_constants.dart';
import '../../../core/constants/input_limits.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../chat_line/chat_line.dart';
import '../sliding_chat_box/sliding_chat_box_view_model.dart';
import 'chat_panel_content_view_model.dart';

class ChatPanelContent extends StatefulWidget {
  final ChatTab activeTab;

  const ChatPanelContent({required this.activeTab, super.key});

  @override
  State<ChatPanelContent> createState() => _ChatPanelContentState();
}

class _ChatPanelContentState extends State<ChatPanelContent>
    with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  late final ChatPanelContentViewModel _viewModel;
  late final VoidCallback _scrollEffectDispose;
  bool _isFiltered = false;

  final List<String> _emojis = ChatConstants.defaultEmojis;
  int _selectedEmojiIndex = 0;

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeTime;

  double _previousKeyboardHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _viewModel = GetIt.I<ChatPanelContentViewModel>();
    _viewModel.loadMessages();
    _setupShakeDetection();

    _scrollEffectDispose = effect(() {
      final messages = _viewModel.messages.value;
      if (messages.isEmpty) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scrollController.hasClients) return;

        final position = _scrollController.position;
        final isAtBottom = position.pixels >= position.maxScrollExtent - 100;

        if (isAtBottom || position.pixels == 0) {
          _scrollController.jumpTo(position.maxScrollExtent);
        }
      });
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    final currentKeyboardHeight =
        // ignore: deprecated_member_use
        WidgetsBinding.instance.window.viewInsets.bottom;

    if (_previousKeyboardHeight > 0 && currentKeyboardHeight == 0) {
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
    }

    _previousKeyboardHeight = currentKeyboardHeight;
  }

  void _setupShakeDetection() {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    _accelerometerSubscription = accelerometerEventStream().listen(
      _detectShake,
    );
  }

  void _detectShake(AccelerometerEvent event) {
    final now = DateTime.now();

    if (_lastShakeTime != null &&
        now.difference(_lastShakeTime!).inMilliseconds <
            ChatConstants.shakeCooldownMs) {
      return;
    }

    if (event.y.abs() > ChatConstants.shakeThresholdVertical &&
        event.x.abs() < ChatConstants.shakeDeadZone) {
      _lastShakeTime = now;
      _viewModel.resendLastMessage();
    } else if (event.x.abs() > ChatConstants.shakeThresholdHorizontal &&
        event.y.abs() < ChatConstants.shakeDeadZone) {
      _lastShakeTime = now;
      _sendEmoji(_emojis[_selectedEmojiIndex]);
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    _viewModel.sendMessage(text);
    _messageController.clear();
    _focusNode.requestFocus();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_scrollController.hasClients) {
        await _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendEmoji(String emoji) {
    _viewModel.sendEmoji(emoji);
  }

  void _selectEmoji(int index) {
    setState(() {
      _selectedEmojiIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.activeTab == ChatTab.journal) {
      return Expanded(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  l10n.emptyJournal,
                  style: const TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    fontFamily: 'CustomFont',
                  ),
                ),
              ),
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
                    child: GestureDetector(
                      onTap: () => setState(() => _isFiltered = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _isFiltered
                              ? const Color(0xFF550000)
                              : const Color(0xFF2B2B2B),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _isFiltered
                                ? const Color(0xFF7F1F1F)
                                : const Color(0xFF444444),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            l10n.filter,
                            style: const TextStyle(
                              color: Color(0xFFF5E6E6),
                              fontSize: 14,
                              fontFamily: 'CustomFont',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isFiltered = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_isFiltered
                              ? const Color(0xFF550000)
                              : const Color(0xFF2B2B2B),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: !_isFiltered
                                ? const Color(0xFF7F1F1F)
                                : const Color(0xFF444444),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            l10n.none,
                            style: const TextStyle(
                              color: Color(0xFFF5E6E6),
                              fontSize: 14,
                              fontFamily: 'CustomFont',
                            ),
                          ),
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

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Watch.builder(
              builder: (context) {
                final uiMessages = _viewModel.uiMessages.value;
                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  itemCount: uiMessages.length,
                  itemBuilder: (context, index) {
                    final message = uiMessages[index];
                    return ChatLine(
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
                      controller: _messageController,
                      focusNode: _focusNode,
                      style: const TextStyle(
                        color: Color(0xFFF5E6E6),
                        fontSize: 14,
                        fontFamily: 'CustomFont',
                      ),
                      cursorColor: const Color(0xFF7F1F1F),
                      backgroundCursorColor: Colors.grey,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                          InputLimits.chatMessage,
                        ),
                      ],
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ..._emojis.asMap().entries.map((entry) {
                  final index = entry.key;
                  final emoji = entry.value;
                  final isSelected = index == _selectedEmojiIndex;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: GestureDetector(
                      onTap: () => _selectEmoji(index),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF550000)
                              : const Color(0xFF2B2B2B),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF7F1F1F)
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
                }),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollEffectDispose();
    unawaited(_accelerometerSubscription?.cancel());
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

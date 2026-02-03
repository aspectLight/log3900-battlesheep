import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/entities/chat_message_entity.dart';
import '../../generated/l10n/app_localizations.dart';
import '../view_models/chat_view_model.dart';

@RoutePage()
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late final ChatViewModel _viewModel;
  late final FocusNode _messageFocusNode;

  final List<String> _emojis = ['👍', '❤️', '😂'];

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeTime;

  static const double _shakeThresholdVertical = 15;
  static const double _shakeThresholdHorizontal = 15;
  static const int _shakeCooldownMs = 1000;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<ChatViewModel>();
    _messageFocusNode = FocusNode();
    _viewModel.loadMessages();
    _setupShakeDetection();
  }

  void _setupShakeDetection() {
    _accelerometerSubscription = accelerometerEventStream().listen(
      _detectShake,
    );
  }

  void _detectShake(AccelerometerEvent event) {
    final now = DateTime.now();

    if (_lastShakeTime != null &&
        now.difference(_lastShakeTime!).inMilliseconds < _shakeCooldownMs) {
      return;
    }

    if (event.y.abs() > _shakeThresholdVertical && event.x.abs() < 10) {
      _lastShakeTime = now;
      _viewModel.sendEmoji(_emojis[0]);
    } else if (event.x.abs() > _shakeThresholdHorizontal &&
        event.y.abs() < 10) {
      _lastShakeTime = now;
      _viewModel.resendLastMessage();
    }
  }

  @override
  Future<void> dispose() async {
    _messageController.dispose();
    _messageFocusNode.dispose();
    await _accelerometerSubscription?.cancel();
    _viewModel.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _viewModel.sendMessage(text);
    _messageController.clear();
    _messageFocusNode.requestFocus();
  }

  void _sendEmoji(String emoji) {
    _viewModel.sendEmoji(emoji);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.chat),
        actions: [
          Watch((context) {
            final isConnected = _viewModel.isConnected.value;
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                isConnected ? Icons.circle : Icons.circle_outlined,
                color: isConnected ? Colors.green : Colors.red,
                size: 12,
              ),
            );
          }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Watch((context) {
              final messages = _viewModel.messages.value;

              if (messages.isEmpty) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.noMessages,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[messages.length - 1 - index];
                  return _buildMessageBubble(message);
                },
              );
            }),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessageEntity message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: message.isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (message.name != null)
              Text(
                message.name!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            Container(
              padding:
                  (message.type == 'emoji-received' ||
                      message.type == 'emoji-sent')
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration:
                  (message.type == 'emoji-received' ||
                      message.type == 'emoji-sent')
                  ? null
                  : BoxDecoration(
                      color: message.isMe
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
              child: Text(
                message.content,
                style: TextStyle(
                  fontSize:
                      (message.type == 'emoji-received' ||
                          message.type == 'emoji-sent')
                      ? 32
                      : 16,
                  color: message.isMe ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Text(
              message.time,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _messageFocusNode,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.typeMessage,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          ..._emojis.map((emoji) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: InkWell(
                onTap: () => _sendEmoji(emoji),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 20)),
                ),
              ),
            );
          }),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

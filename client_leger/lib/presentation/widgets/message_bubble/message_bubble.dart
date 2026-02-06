import 'package:flutter/material.dart';
import '../../ui_models/chat_ui_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatUiMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
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
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[400],
                  fontFamily: 'CustomFont',
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
                  fontFamily: 'CustomFont',
                ),
              ),
            ),
            Text(
              message.time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontFamily: 'CustomFont',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

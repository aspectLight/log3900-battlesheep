import 'package:flutter/material.dart';
import '../../ui_models/chat_ui_message.dart';

class ChatLine extends StatelessWidget {
  final ChatUiMessage message;

  const ChatLine({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: message.isMe ? const Color(0xFF220808) : const Color(0xFF180505),
        border: const Border(bottom: BorderSide(color: Color(0xFF250808))),
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
            if (message.name != null)
              TextSpan(
                text: '${message.name}: ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'CustomFont',
                ),
              ),
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

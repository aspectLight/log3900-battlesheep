import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/models/channel_message.dart';
import '../screens/discussion_canals_view_model.dart';

const _kBorder = Color(0xFF3a3a3a);
const _kStateBg = Color(0x40000000);
const _kHeaderText = Color(0xFFe0d8c0);
const _kPrimary = Color(0xFF8b0000);

class JoinedChannelsSection extends StatefulWidget {
  const JoinedChannelsSection({super.key, required this.viewModel});

  final DiscussionCanalsViewModel viewModel;

  @override
  State<JoinedChannelsSection> createState() => _JoinedChannelsSectionState();
}

class _JoinedChannelsSectionState extends State<JoinedChannelsSection> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final id = widget.viewModel.activeChannelId.value;
    final content = _messageController.text.trim();
    if (id == null || content.isEmpty) return;
    widget.viewModel.sendMessage(id, content);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final joinedIds = widget.viewModel.joinedChannelIds.value;
      final activeId = widget.viewModel.activeChannelId.value;
      final messages = widget.viewModel.channelMessages.value;
      if (joinedIds.isEmpty)
        return _buildState('Rejoignez un canal pour commencer à discuter.');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabs(joinedIds, activeId),
          const SizedBox(height: 8),
          if (activeId != null)
            _buildChatPanel(activeId, messages)
          else
            _buildState(
              'Sélectionnez un canal rejoint pour afficher la discussion.',
            ),
        ],
      );
    });
  }

  Widget _buildTabs(List<String> ids, String? activeId) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ids.map((id) {
        final isActive = activeId == id;
        return GestureDetector(
          onTap: () => widget.viewModel.setActiveChannel(id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0x808b0000)
                  : const Color(0x66000000),
              border: Border.all(color: isActive ? _kPrimary : _kBorder),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              widget.viewModel.getChannelName(id),
              style: TextStyle(
                color: isActive ? Colors.white : _kHeaderText,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChatPanel(String channelId, List<ChannelMessage> messages) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x66000000),
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${widget.viewModel.getChannelName(channelId)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'CustomFont',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              OutlinedButton(
                onPressed: () => widget.viewModel.leaveChannel(channelId),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFff6b6b),
                  side: const BorderSide(color: Color(0xFF7f1f1f)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Quitter ce canal',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildMessages(messages),
          const SizedBox(height: 8),
          _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildMessages(List<ChannelMessage> messages) {
    if (messages.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0x59000000),
          border: Border.all(color: _kBorder),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Center(
          child: Text(
            "Aucun message pour l'instant.",
            style: TextStyle(color: _kHeaderText),
          ),
        ),
      );
    }
    return Container(
      constraints: const BoxConstraints(maxHeight: 260),
      decoration: BoxDecoration(
        color: const Color(0x59000000),
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        itemCount: messages.length,
        itemBuilder: (_, i) => _buildMessageRow(messages[i]),
      ),
    );
  }

  Widget _buildMessageRow(ChannelMessage msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            msg.time,
            style: const TextStyle(color: Color(0xFFaaaaaa), fontSize: 12),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 13,
            backgroundColor: const Color(0xFF4a3010),
            child: Text(
              (msg.senderName.isNotEmpty ? msg.senderName[0] : '?')
                  .toUpperCase(),
              style: const TextStyle(
                color: Color(0xFFffd39a),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            msg.senderName,
            style: const TextStyle(
              color: Color(0xFFffd39a),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              msg.content,
              style: const TextStyle(color: Color(0xFFF0F0F0), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            maxLength: 200,
            style: const TextStyle(color: Color(0xFFF0F0F0), fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Écrire un message...',
              hintStyle: const TextStyle(color: Color(0xFF666666)),
              counterText: '',
              filled: true,
              fillColor: const Color(0x66000000),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFF3a1212)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFF3a1212)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: _kPrimary),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            onSubmitted: (_) => _sendMessage(),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _sendMessage,
          style: ElevatedButton.styleFrom(
            backgroundColor: _kPrimary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            'Envoyer',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
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
}

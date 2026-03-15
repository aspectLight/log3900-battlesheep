import 'package:flutter/material.dart';

import '../../domain/models/channel_info.dart';

const _kRowBg = Color(0xFF2b2b2b);
const _kBorder = Color(0xFF3a3a3a);

class ChannelRowWidget extends StatelessWidget {
  const ChannelRowWidget({
    super.key,
    required this.channel,
    required this.isLast,
    required this.isJoined,
    required this.isCreator,
    required this.onJoin,
    required this.onLeave,
    required this.onDelete,
  });

  final ChannelInfo channel;
  final bool isLast;
  final bool isJoined;
  final bool isCreator;
  final VoidCallback onJoin;
  final VoidCallback onLeave;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: _kRowBg,
        border: Border(
          left: BorderSide(
            color: isCreator ? const Color(0xFF8b0000) : _kBorder,
            width: isCreator ? 3 : 1,
          ),
          right: const BorderSide(color: _kBorder),
          bottom: const BorderSide(color: _kBorder),
        ),
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(8))
            : null,
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: _buildName()),
          Expanded(
            flex: 2,
            child: Text(
              channel.creator,
              style: const TextStyle(color: Color(0xFFb0b0b0), fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              '${channel.memberCount}',
              style: const TextStyle(color: Color(0xFFa0c8ff), fontSize: 14),
            ),
          ),
          Expanded(flex: 2, child: _buildActions()),
        ],
      ),
    );
  }

  Widget _buildName() {
    return Row(
      children: [
        Flexible(
          child: Text(
            channel.name,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'CustomFont',
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        if (isCreator) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0x598b0000),
              border: Border.all(color: const Color(0xFF8b0000)),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Vous',
              style: TextStyle(
                color: Color(0xFFff9090),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isJoined)
          _ActionButton(
            label: 'Quitter',
            color: const Color(0xFFffb347),
            border: const Color(0xFF8b5a00),
            onPressed: onLeave,
          )
        else
          _ActionButton(
            label: 'Joindre',
            color: Colors.white,
            bg: const Color(0xFF145214),
            onPressed: onJoin,
          ),
        if (isCreator) ...[
          const SizedBox(width: 6),
          _ActionButton(
            label: 'Supprimer',
            color: const Color(0xFFff6b6b),
            border: const Color(0xFF7f1f1f),
            onPressed: onDelete,
          ),
        ],
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
    this.bg,
    this.border,
  });

  final String label;
  final Color color;
  final Color? bg;
  final Color? border;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        backgroundColor: bg ?? Colors.transparent,
        side: border != null ? BorderSide(color: border!) : BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

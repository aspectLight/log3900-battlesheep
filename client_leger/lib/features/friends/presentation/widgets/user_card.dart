import 'package:flutter/material.dart';

const _kRowBg = Color(0xFF2b2b2b);
const _kBorder = Color(0xFF3a3a3a);

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.username,
    required this.actions,
    this.isOnline,
    this.avatarId,
  });

  final String username;
  final bool? isOnline;
  final String? avatarId;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        color: _kRowBg,
        border: Border.all(color: _kBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                if (avatarId != null) ...[
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFF4a3010),
                    child: Text(
                      username.isNotEmpty ? username[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Color(0xFFffd39a),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'CustomFont',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                if (isOnline != null) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isOnline!
                          ? const Color(0x2632B464)
                          : const Color(0x26888888),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      isOnline! ? 'En ligne' : 'Hors ligne',
                      style: TextStyle(
                        color: isOnline!
                            ? const Color(0xFF32B464)
                            : Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Row(children: actions),
        ],
      ),
    );
  }
}

class FriendActionButton extends StatelessWidget {
  const FriendActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = const Color(0xFFff6b6b),
    this.bg = Colors.transparent,
    this.borderColor = const Color(0xFF7f1f1f),
  });

  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color bg;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          backgroundColor: bg,
          side: BorderSide(color: borderColor),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class WaitingRoomJoinQrCorner extends StatelessWidget {
  const WaitingRoomJoinQrCorner({
    super.key,
    required this.roomId,
    required this.semanticLabel,
  });

  final String roomId;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final String trimmed = roomId.trim();
    if (trimmed.length != 4) {
      return const SizedBox.shrink();
    }
    return Semantics(
      label: semanticLabel,
      child: Material(
        color: Colors.white,
        elevation: 6,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: QrImageView(
            data: trimmed,
            size: 88,
            backgroundColor: Colors.white,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Color(0xFF1a0505),
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Color(0xFF1a0505),
            ),
          ),
        ),
      ),
    );
  }
}

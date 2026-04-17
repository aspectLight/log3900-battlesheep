import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/localisation/join_game_session_localizations.dart';
import '../../../core/utils/join_game_session_qr_payload_parser.dart';

class JoinQrScannerDialog extends StatefulWidget {
  const JoinQrScannerDialog({super.key});

  @override
  State<JoinQrScannerDialog> createState() => _JoinQrScannerDialogState();
}

class _JoinQrScannerDialogState extends State<JoinQrScannerDialog> {
  late final MobileScannerController _controller;
  bool _handled = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      formats: const <BarcodeFormat>[BarcodeFormat.qrCode],
      cameraResolution: const Size(1920, 1080),
    );
  }

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) {
      return;
    }
    for (final Barcode barcode in capture.barcodes) {
      final String? raw = barcode.rawValue;
      if (raw == null || raw.isEmpty) {
        continue;
      }
      final String? parsed = JoinGameSessionQrPayloadParser.tryParseRoomCode(
        raw,
      );
      if (parsed != null) {
        _handled = true;
        Navigator.of(context).pop<String>(parsed);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final JoinGameSessionLocalizations l10n = JoinGameSessionLocalizations.of(
      context,
    )!;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: Colors.black,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              MobileScanner(
                controller: _controller,
                onDetect: _onDetect,
                tapToFocus: true,
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Material(
                  color: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            l10n.joinGameScanQrTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'CustomFont',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

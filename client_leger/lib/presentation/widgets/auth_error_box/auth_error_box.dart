import 'package:flutter/material.dart';

class AuthErrorBox extends StatelessWidget {
  final String? errorMessage;

  const AuthErrorBox({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    if (errorMessage == null || errorMessage!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFDC3545).withValues(alpha: 0.2),
        border: Border.all(color: const Color(0xFFDC3545)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        errorMessage!,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFFDC3545),
          fontSize: 16,
          fontFamily: 'CustomFont',
        ),
      ),
    );
  }
}

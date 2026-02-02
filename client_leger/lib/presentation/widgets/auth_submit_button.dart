import 'package:flutter/material.dart';

class AuthSubmitButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const AuthSubmitButton({
    super.key,
    required this.label,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE34B4B)),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF550000),
          foregroundColor: const Color(0xFFF5E6E6),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
          side: const BorderSide(color: Color(0xFF7F1F1F), width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          textStyle: const TextStyle(
            fontSize: 19.2, // 1.2rem
            fontWeight: FontWeight.w600,
            fontFamily: 'CustomFont',
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

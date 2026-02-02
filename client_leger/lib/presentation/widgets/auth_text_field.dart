import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onFocusLost;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool enabled;

  const AuthTextField({
    super.key,
    required this.label,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onEditingComplete,
    this.onFocusLost,
    this.controller,
    this.suffixIcon,
    this.enabled = true,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      if (!_focusNode.hasFocus) {
        widget.onFocusLost?.call();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    final isFocused = _focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: Color(0xFFF5E6E6),
            fontSize: 14,
            fontFamily: 'CustomFont',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF2B2B2B),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: hasError
                      ? const Color(0xFFDC3545)
                      : (isFocused
                            ? const Color(0xFF7F1F1F)
                            : const Color(0xFF444444)),
                  width: 2,
                ),
              ),
            ),
            if (isFocused)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFFDC3545).withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5],
                      ),
                    ),
                  ),
                ),
              ),
            TextField(
              focusNode: _focusNode,
              controller: widget.controller,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              onChanged: widget.onChanged,
              onEditingComplete: widget.onEditingComplete,
              enabled: widget.enabled,
              style: const TextStyle(
                color: Color(0xFFF5E6E6),
                fontFamily: 'CustomFont',
                fontSize: 16,
              ),
              cursorColor: const Color(0xFFF5E6E6),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: Colors.white30,
                  fontFamily: 'CustomFont',
                ),
                suffixIcon: widget.suffixIcon,
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.all(12),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ],
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: const TextStyle(
              color: Color(0xFFDC3545),
              fontFamily: 'CustomFont',
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

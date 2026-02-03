import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final String? errorText;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onFocusLost;
  final TextEditingController? controller;
  final bool enabled;
  final int? maxLength;

  const PasswordTextField({
    super.key,
    required this.label,
    this.hintText,
    this.errorText,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onEditingComplete,
    this.onFocusLost,
    this.controller,
    this.enabled = true,
    this.maxLength,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;
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

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
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
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: const TextStyle(
              color: Color(0xFFF5E6E6),
              fontSize: 20,
              fontFamily: 'CustomFont',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Stack(
          children: [
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: hasError
                      ? const Color(0xFFDC3545)
                      : (isFocused
                            ? const Color(0xFFC60D0D)
                            : const Color(0xFF333333)),
                  width: 1.5,
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
              obscureText: _obscureText,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: widget.textInputAction,
              onChanged: widget.onChanged,
              onEditingComplete: widget.onEditingComplete,
              enabled: widget.enabled,
              maxLength: widget.maxLength,
              maxLengthEnforcement: widget.maxLength != null
                  ? MaxLengthEnforcement.enforced
                  : MaxLengthEnforcement.none,
              buildCounter:
                  (
                    context, {
                    required currentLength,
                    required isFocused,
                    required maxLength,
                  }) => null,
              inputFormatters: widget.maxLength != null
                  ? [LengthLimitingTextInputFormatter(widget.maxLength)]
                  : null,
              style: const TextStyle(
                color: Color(0xFFF5E6E6),
                fontFamily: 'CustomFont',
                fontSize: 18,
              ),
              cursorColor: const Color(0xFFF5E6E6),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: Colors.white30,
                  fontFamily: 'CustomFont',
                ),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.all(12),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70,
                  ),
                  onPressed: _toggleVisibility,
                ),
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
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }
}

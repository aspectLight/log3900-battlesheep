import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_interaction_colors.dart';
import '../../../../../core/constants/ui_assets.dart';
import '../../../core/constants/auth_constants.dart';
import '../../../core/extensions/auth_exception_ext.dart';
import '../../../core/extensions/auth_validation_error_ext.dart';
import '../../../../../core/helpers/functional_programming.dart';
import '../../../core/localisation/auth_localizations.dart';
import '../../../../../routing/app_navigator.dart';
import '../../../../../routing/navigation_command.dart';
import '../../../../../core/presentation/widgets/app_background/app_background.dart';

import '../../../domain/state/auth_state.dart';
import 'login_view_model.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginViewModel _viewModel;
  late final AppNavigator _appNavigator;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<LoginViewModel>();
    _appNavigator = GetIt.I<AppNavigator>();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(UiAssets.logo, width: 450, fit: BoxFit.contain),
                    const SizedBox(height: 32),
                    _buildForm(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AuthLocalizations.of(context)!.noAccount,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontFamily: 'CustomFont',
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _appNavigator.request(GoToSignUp()),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 12,
                            ),
                            child: Text(
                              AuthLocalizations.of(context)!.signUp,
                              style: const TextStyle(
                                color: kAuthFieldFocusGlow,
                                fontFamily: 'CustomFont',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                                decorationColor: kAuthFieldFocusGlow,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 40,
      left: 20,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _appNavigator.request(GoToAuth()),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.chevron_left, color: Colors.white, size: 32),
                const SizedBox(width: 4),
                Text(
                  AuthLocalizations.of(context)!.back,
                  style: const TextStyle(
                    color: Color(0xFFE34B4B),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'CustomFont',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    final l10n = AuthLocalizations.of(context)!;
    return Column(
      children: [
        Watch((context) {
          final state = _viewModel.authState.value;
          final isLoading = state is AuthStateLoading;
          return _AuthTextField(
            label: l10n.username,
            hintText: l10n.usernamePlaceholder,
            errorText: _viewModel.usernameError.value.when(
              none: () => null,
              some: (e) => e.localize(l10n),
            ),
            onChanged: _viewModel.updateUsername,
            onFocusLost: _viewModel.markUsernameTouched,
            enabled: !isLoading,
            maxLength: AuthConstants.usernameMaxLength,
          );
        }),
        const SizedBox(height: 20),
        Watch((context) {
          final state = _viewModel.authState.value;
          final isLoading = state is AuthStateLoading;
          return _PasswordTextField(
            label: l10n.password,
            hintText: l10n.passwordPlaceholder,
            errorText: _viewModel.passwordError.value.when(
              none: () => null,
              some: (e) => e.localize(l10n),
            ),
            onChanged: _viewModel.updatePassword,
            onFocusLost: _viewModel.markPasswordTouched,
            enabled: !isLoading,
            textInputAction: TextInputAction.done,
            onEditingComplete: _viewModel.signInSubmit,
            maxLength: AuthConstants.passwordMaxLength,
          );
        }),
        const SizedBox(height: 20),
        Watch((context) {
          final state = _viewModel.authState.value;
          final errorMessage = state is AuthStateError
              ? state.exception.localize(l10n)
              : null;
          if (errorMessage == null) return const SizedBox.shrink();
          return Column(
            children: [
              _AuthErrorBox(errorMessage: errorMessage),
              const SizedBox(height: 12),
            ],
          );
        }),
        Watch((context) {
          final state = _viewModel.authState.value;
          final isLoading = state is AuthStateLoading;
          final label = isLoading ? l10n.signingIn : l10n.signIn;
          return _AuthButton(
            label: label,
            isLoading: isLoading,
            onPressed: _viewModel.signInSubmit,
          );
        }),
      ],
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _AuthButton({
    required this.label,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF6B0000),
          foregroundColor: const Color(0xFFF5E6E6),
          disabledBackgroundColor: const Color(0xFF4A0000),
          disabledForegroundColor: Colors.white54,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          side: const BorderSide(color: Color(0xFF4A0000), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _AuthErrorBox extends StatelessWidget {
  final String? errorMessage;

  const _AuthErrorBox({this.errorMessage});

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

class _AuthTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFocusLost;
  final bool enabled;
  final int? maxLength;

  const _AuthTextField({
    required this.label,
    this.hintText,
    this.errorText,
    this.onChanged,
    this.onFocusLost,
    this.enabled = true,
    this.maxLength,
  });

  @override
  State<_AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<_AuthTextField> {
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
    final maxLength = widget.maxLength;

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
                            ? kAuthFieldFocusBorder
                            : const Color(0xFF333333)),
                  width: 1.5,
                ),
              ),
            ),
            if (isFocused && !hasError)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          kAuthFieldFocusGlow.withValues(alpha: 0.3),
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
              onChanged: widget.onChanged,
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
              inputFormatters: maxLength != null
                  ? [LengthLimitingTextInputFormatter(maxLength)]
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

class _PasswordTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final String? errorText;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onFocusLost;
  final bool enabled;
  final int? maxLength;

  const _PasswordTextField({
    required this.label,
    this.hintText,
    this.errorText,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onEditingComplete,
    this.onFocusLost,
    this.enabled = true,
    this.maxLength,
  });

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
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
                            ? kAuthFieldFocusBorder
                            : const Color(0xFF333333)),
                  width: 1.5,
                ),
              ),
            ),
            if (isFocused && !hasError)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          kAuthFieldFocusGlow.withValues(alpha: 0.3),
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

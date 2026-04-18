import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/constants/ui_assets.dart';
import '../../../../../core/presentation/widgets/selfie_capture/selfie_capture_page.dart';
import '../../../core/constants/auth_constants.dart';
import '../../../core/enums/auth_validation_error.dart';
import '../../../core/extensions/auth_exception_ext.dart';
import '../../../core/extensions/auth_validation_error_ext.dart';
import '../../../../../core/helpers/functional_programming.dart';
import '../../../core/localisation/auth_localizations.dart';
import '../../../../../core/presentation/widgets/app_background/app_background.dart';
import '../../widgets/avatar_picker/avatar_picker.dart';
import '../../widgets/avatar_picker/avatar_picker_view_model.dart';
import '../../../../../routing/app_navigator.dart';
import '../../../../../routing/navigation_command.dart';

import '../../../domain/state/auth_state.dart';
import 'sign_up_view_model.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  static const int _maxAvatarBytes = 4 * 1024 * 1024;
  static const Set<String> _allowedAvatarExtensions = {'jpg', 'jpeg', 'png'};

  late final SignUpViewModel _viewModel;
  late final AvatarPickerViewModel _avatarPickerViewModel;
  late final AppNavigator _appNavigator;
  final _imagePicker = ImagePicker();
  String? _customAvatarError;

  bool get _supportsCameraCapture => Platform.isAndroid || Platform.isIOS;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<SignUpViewModel>();
    _avatarPickerViewModel = GetIt.I<AvatarPickerViewModel>();
    _appNavigator = GetIt.I<AppNavigator>();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _avatarPickerViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogo(),
                  const SizedBox(height: 48),
                  _buildMainContainer(),
                  const SizedBox(height: 32),
                  _buildSubmitSection(),
                ],
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

  Widget _buildLogo() {
    return Image.asset(UiAssets.logo, height: 220);
  }

  Widget _buildMainContainer() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _SignUpForm(
              viewModel: _viewModel,
              onSubmit: _handleFormSubmit,
            ),
          ),
          const SizedBox(width: 64),
          SizedBox(
            width: 450,
            child: Watch(
              (context) => AvatarPicker(
                viewModel: _avatarPickerViewModel,
                onSelectionChange: (avatar) {
                  setState(() {
                    _customAvatarError = null;
                  });
                  _viewModel.selectAvatar(avatar);
                },
                onPickFromGallery: () =>
                    unawaited(_pickCustomAvatar(ImageSource.gallery)),
                onPickFromCamera: () =>
                    unawaited(_pickCustomAvatar(ImageSource.camera)),
                customAvatarPath: _viewModel.formState.value.customAvatarPath,
                customAvatarError: _customAvatarError,
                error: _viewModel.avatarError.value.when(
                  none: () => null,
                  some: (e) => e.localize(AuthLocalizations.of(context)!),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleFormSubmit() {
    unawaited(_viewModel.signUpSubmit());
  }

  Future<void> _pickCustomAvatar(ImageSource source) async {
    final l10n = AuthLocalizations.of(context)!;
    if (source == ImageSource.camera && !_supportsCameraCapture) {
      setState(() {
        _customAvatarError = l10n.avatarUploadFallbackWarning;
      });
      return;
    }
    try {
      final XFile picked;
      if (source == ImageSource.camera) {
        final path = await openSelfieCapture(context);
        if (path == null) return;
        picked = XFile(path);
      } else {
        final file = await _imagePicker.pickImage(source: source);
        if (file == null) return;
        picked = file;
      }
      final error = await _validateCustomAvatar(picked, l10n);
      if (error != null) {
        setState(() {
          _customAvatarError = error;
        });
        return;
      }
      setState(() {
        _customAvatarError = null;
      });
      _avatarPickerViewModel.reset();
      _viewModel.setCustomAvatarPath(picked.path);
    } on Object {
      setState(() {
        _customAvatarError = l10n.avatarUploadFallbackWarning;
      });
    }
  }

  Future<String?> _validateCustomAvatar(
    XFile file,
    AuthLocalizations l10n,
  ) async {
    final extension = file.name.contains('.')
        ? file.name.split('.').last.toLowerCase()
        : '';
    if (!_allowedAvatarExtensions.contains(extension)) {
      return l10n.avatarInvalidFileType;
    }
    final size = await file.length();
    if (size > _maxAvatarBytes) {
      return l10n.avatarFileTooLarge;
    }
    return null;
  }

  Widget _buildSubmitSection() {
    final l10n = AuthLocalizations.of(context)!;
    return Column(
      children: [
        Watch((context) {
          final state = _viewModel.authState.value;
          final errorMessage = state is AuthStateError
              ? state.exception.localize(l10n)
              : null;
          if (errorMessage == null) return const SizedBox.shrink();
          return Column(
            children: [
              SizedBox(
                width: 450,
                child: _AuthErrorBox(errorMessage: errorMessage),
              ),
              const SizedBox(height: 12),
            ],
          );
        }),
        Watch((context) {
          if (!_viewModel.customAvatarUploadFailed.value) {
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              SizedBox(
                width: 450,
                child: _AuthErrorBox(
                  errorMessage: l10n.avatarUploadFallbackWarning,
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        }),
        Watch((context) {
          final state = _viewModel.authState.value;
          final isLoading = state is AuthStateLoading;
          final label = isLoading ? l10n.signingUp : l10n.signUp;
          return SizedBox(
            width: 450,
            child: _AuthButton(
              label: label,
              isLoading: isLoading,
              onPressed: _handleFormSubmit,
            ),
          );
        }),
        const SizedBox(height: 12),
        _buildSwitchToLogin(),
      ],
    );
  }

  Widget _buildSwitchToLogin() {
    final l10n = AuthLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.alreadyHaveAccount,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'CustomFont',
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _appNavigator.request(GoToLogin()),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Text(
              l10n.signIn,
              style: const TextStyle(
                color: Color(0xFFC60D0D),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'CustomFont',
              ),
            ),
          ),
        ),
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

class _SignUpForm extends StatelessWidget {
  const _SignUpForm({required this.viewModel, required this.onSubmit});

  final SignUpViewModel viewModel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AuthLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(l10n.username),
        const SizedBox(height: 6),
        Watch((context) {
          final state = viewModel.authState.value;
          final isLoading = state is AuthStateLoading;
          return _AuthTextField(
            hintText: l10n.usernamePlaceholder,
            onChanged: viewModel.setUsername,
            enabled: !isLoading,
            maxLength: AuthConstants.usernameMaxLength,
          );
        }),
        Watch(
          (context) =>
              _AuthValidationErrors(errors: viewModel.usernameErrors.value),
        ),
        const SizedBox(height: 12),
        _buildLabel(l10n.email),
        const SizedBox(height: 6),
        Watch((context) {
          final state = viewModel.authState.value;
          final isLoading = state is AuthStateLoading;
          return _AuthTextField(
            hintText: l10n.emailPlaceholder,
            onChanged: viewModel.setEmail,
            enabled: !isLoading,
            keyboardType: TextInputType.emailAddress,
            maxLength: AuthConstants.emailMaxLength,
          );
        }),
        Watch(
          (context) =>
              _AuthValidationErrors(errors: viewModel.emailErrors.value),
        ),
        const SizedBox(height: 12),
        _buildLabel(l10n.password),
        const SizedBox(height: 6),
        Watch((context) {
          final state = viewModel.authState.value;
          final isLoading = state is AuthStateLoading;
          return _PasswordTextField(
            hintText: l10n.passwordPlaceholder,
            onChanged: viewModel.setPassword,
            enabled: !isLoading,
            maxLength: AuthConstants.passwordMaxLength,
          );
        }),
        Watch(
          (context) =>
              _AuthValidationErrors(errors: viewModel.passwordErrors.value),
        ),
        const SizedBox(height: 12),
        _buildLabel(l10n.confirmPassword),
        const SizedBox(height: 6),
        Watch((context) {
          final state = viewModel.authState.value;
          final isLoading = state is AuthStateLoading;
          return _PasswordTextField(
            hintText: l10n.passwordPlaceholder,
            onChanged: viewModel.setConfirmPassword,
            enabled: !isLoading,
            textInputAction: TextInputAction.done,
            onEditingComplete: onSubmit,
            maxLength: AuthConstants.passwordMaxLength,
          );
        }),
        Watch(
          (context) => _AuthValidationErrors(
            errors: viewModel.confirmPasswordErrors.value,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'CustomFont',
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _AuthTextField extends StatefulWidget {
  final String? hintText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final int? maxLength;

  const _AuthTextField({
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.onChanged,
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
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;
    final maxLength = widget.maxLength;

    return Stack(
      children: [
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isFocused
                  ? const Color(0xFFC60D0D)
                  : const Color(0xFF333333),
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
          keyboardType: widget.keyboardType,
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
    );
  }
}

class _AuthValidationErrors extends StatelessWidget {
  const _AuthValidationErrors({required this.errors});

  final List<AuthValidationError> errors;

  @override
  Widget build(BuildContext context) {
    if (errors.isEmpty) {
      return const SizedBox.shrink();
    }

    final l10n = AuthLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: errors
          .map(
            (error) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                error.localize(l10n),
                style: const TextStyle(
                  color: Color(0xFFE34B4B),
                  fontSize: 12,
                  fontFamily: 'CustomFont',
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  final String? hintText;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final bool enabled;
  final int? maxLength;

  const _PasswordTextField({
    this.hintText,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onEditingComplete,
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
    setState(() {});
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
    final isFocused = _focusNode.hasFocus;

    return Stack(
      children: [
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isFocused
                  ? const Color(0xFFC60D0D)
                  : const Color(0xFF333333),
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
    );
  }
}

import 'dart:io';
import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:fpdart/fpdart.dart' show Option;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_interaction_colors.dart';
import '../../../../../core/config/env_config.dart';
import '../../../../../core/constants/auth_avatar_assets.dart';
import '../../../../../core/constants/ui_assets.dart';
import '../../../../../core/enums/auth_avatar.dart';
import '../../../../../core/enums/shop_catalog_item_id.dart';
import '../../../../../core/localisation/core_localizations.dart';
import '../../../../../core/modal/modal_coordinator.dart';
import '../../../../../core/modal/modal_intent_sink.dart';
import '../../../../../core/presentation/widgets/app_background/app_background.dart';
import '../../../../shop/data/repositories/shop_repository.dart';
import '../../../../shop/domain/state/shop_state.dart';
import '../../../../authentication/core/constants/auth_constants.dart';
import '../../../../authentication/core/enums/auth_validation_error.dart';
import '../../../../authentication/core/extensions/auth_validation_error_ext.dart';
import '../../../../authentication/core/helpers/email_validator.dart';
import '../../../../authentication/core/helpers/username_validator.dart';
import '../../../../authentication/core/localisation/auth_localizations.dart';
import '../../../core/exceptions/profile_failure.dart';
import '../../../core/extensions/profile_failure_ext.dart';
import '../../../core/localisation/profile_localizations.dart';
import '../../../core/modal/profile_modal_intents.dart';
import '../../../domain/commands/profile_commands.dart';
import '../../../domain/models/profile_model.dart';
import '../../../domain/models/profile_statistics_model.dart';
import '../../../domain/state/profile_state.dart';
import 'profile_view_model.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const int _maxAvatarBytes = 2 * 1024 * 1024;
  static const Set<String> _allowedAvatarExtensions = {'jpg', 'jpeg', 'png'};

  late final ProfileViewModel _viewModel;
  late final ShopRepository _shopRepository;
  late final ModalIntentSink _modalIntentSink;
  late final ModalCoordinator _modalCoordinator;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _imagePicker = ImagePicker();
  Timer? _successModalTimer;
  String? _lastLoadErrorMessage;
  String? _avatarFileError;
  bool _hasAttemptedSave = false;
  int _avatarRefreshEpoch = DateTime.now().millisecondsSinceEpoch;

  bool get _supportsCameraCapture => Platform.isAndroid || Platform.isIOS;

  ButtonStyle _uploadButtonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFFF5E6E6),
      backgroundColor: const Color(0x33000000),
      side: const BorderSide(color: Color(0xFF7F1F1F), width: 1.5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      textStyle: const TextStyle(
        fontFamily: 'CustomFont',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    );
  }

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<ProfileViewModel>();
    _shopRepository = GetIt.I<ShopRepository>();
    _modalIntentSink = GetIt.I<ModalIntentSink>();
    _modalCoordinator = GetIt.I<ModalCoordinator>();
    unawaited(_init());
  }

  @override
  void dispose() {
    _successModalTimer?.cancel();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    await _viewModel.load();
    _shopRepository.refreshCatalogueAndBalance();
    _syncFormFromState();
    _presentLoadErrorIfAny();
  }

  void _syncFormFromState() {
    final state = _viewModel.state.value;
    if (state is ProfileStateLoaded) {
      _usernameController.text = state.profile.username;
      _emailController.text = state.profile.email;
      _viewModel.syncSelectedAvatarIdFromProfile(state.profile.avatarId);
      _viewModel.syncPreferencesFromProfile(state.profile);
      _avatarFileError = null;
      _hasAttemptedSave = false;
    }
  }

  Future<void> _pickAvatarImage(ImageSource source) async {
    final l10n = ProfileLocalizations.of(context)!;
    if (source == ImageSource.camera && !_supportsCameraCapture) {
      setState(() {
        _avatarFileError = l10n.profileAvatarUploadFailed;
      });
      return;
    }
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
      );
      if (picked == null) return;
      final error = await _validateAvatarFile(picked, l10n);
      if (error != null) {
        setState(() {
          _avatarFileError = error;
        });
        return;
      }
      setState(() {
        _avatarFileError = null;
        _viewModel.setPendingAvatarFile(picked.path);
      });
    } on Object {
      setState(() {
        _avatarFileError = l10n.profileAvatarUploadFailed;
      });
    }
  }

  Future<String?> _validateAvatarFile(
    XFile file,
    ProfileLocalizations l10n,
  ) async {
    final fileName = file.name.toLowerCase();
    final extension = fileName.contains('.') ? fileName.split('.').last : '';
    if (!_allowedAvatarExtensions.contains(extension)) {
      return l10n.profileAvatarInvalidFileType;
    }
    final size = await file.length();
    if (size > _maxAvatarBytes) {
      return l10n.profileAvatarFileTooLarge;
    }
    return null;
  }

  List<AuthValidationError> _usernameValidationErrors() {
    final errors = UsernameValidator.validateAll(
      Option.of(_usernameController.text.trim()),
    );
    if (errors.isNotEmpty &&
        errors.first == AuthValidationError.usernameRequired &&
        !_hasAttemptedSave) {
      return [];
    }
    return errors;
  }

  List<AuthValidationError> _emailValidationErrors() {
    final errors = EmailValidator.validateAll(
      Option.of(_emailController.text.trim()),
    );
    if (errors.isNotEmpty &&
        errors.first == AuthValidationError.emailRequired &&
        !_hasAttemptedSave) {
      return [];
    }
    return errors;
  }

  Future<void> _retryLoad() async {
    await _viewModel.load();
    _syncFormFromState();
    _presentLoadErrorIfAny();
  }

  void _presentLoadErrorIfAny() {
    final state = _viewModel.state.value;
    if (state is! ProfileStateError) {
      _lastLoadErrorMessage = null;
      return;
    }
    final l10n = ProfileLocalizations.of(context)!;
    final message = state.failure.localize(l10n);
    if (_lastLoadErrorMessage == message) return;
    _lastLoadErrorMessage = message;
    _showProfileModal(
      title: l10n.profileErrorTitle,
      description: message,
      isError: true,
    );
  }

  void _showProfileModal({
    required String title,
    required String description,
    required bool isError,
    String? primaryLabel,
    void Function()? onPrimaryAction,
    String? secondaryLabel,
    void Function()? onSecondaryAction,
    String? modalKey,
  }) {
    final coreL10n = CoreLocalizations.of(context)!;
    _modalIntentSink.addIntent(
      ProfilePopupModalIntent(
        title: title,
        description: description,
        isError: isError,
        primaryLabel: primaryLabel ?? coreL10n.ok,
        onPrimaryAction: onPrimaryAction ?? () {},
        secondaryLabel: secondaryLabel,
        onSecondaryAction: onSecondaryAction,
        modalKey: modalKey,
      ),
    );
  }

  void _dismissSuccessModalIfCurrent(String modalKey) {
    final current = _modalCoordinator.current.value;
    if (current == null) return;
    final intent = current.intent;
    if (intent is! ProfilePopupModalIntent) return;
    if (intent.modalKey != modalKey) return;
    _modalCoordinator.remove(current.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ProfileLocalizations.of(context)!;

    return AppBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 750),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DefaultTextStyle.merge(
                  style: const TextStyle(fontFamily: 'CustomFont'),
                  child: Watch((context) {
                    final state = _viewModel.state.value;
                    final shopState = _shopRepository.state.value;
                    final isSaving = _viewModel.isSaving.value;
                    final isDeleting = _viewModel.isDeleting.value;
                    final isUploading = _viewModel.isUploading.value;
                    final selectedAvatarId = _viewModel.selectedAvatarId.value;
                    _viewModel.avatarPreviewPath.value;
                    _viewModel.selectedThemeId.value;
                    _viewModel.selectedLanguage.value;
                    if (state is ProfileStateLoading) {
                      return const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    }
                    return switch (state) {
                      ProfileStateError() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _retryLoad,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF550000),
                              foregroundColor: const Color(0xFFF5E6E6),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: const BorderSide(
                                  color: Color(0xFF7F1F1F),
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              l10n.profileRetry,
                              style: const TextStyle(
                                fontFamily: 'CustomFont',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ProfileStateLoaded(:final statistics, :final profile) =>
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            _buildContent(
                              l10n,
                              profile,
                              statistics,
                              isSaving,
                              isDeleting,
                              isUploading,
                              selectedAvatarId,
                              shopState,
                              _viewModel.selectedThemeId.value,
                              _viewModel.selectedLanguage.value,
                            ),
                          ],
                        ),
                      _ => const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [SizedBox(height: 8)],
                      ),
                    };
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    ProfileLocalizations l10n,
    ProfileModel profile,
    ProfileStatisticsModel statistics,
    bool isSaving,
    bool isDeleting,
    bool isUploading,
    String selectedAvatarId,
    ShopState shopState,
    String selectedThemeId,
    String selectedLanguage,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildFormColumn(
              l10n,
              profile,
              isSaving,
              isDeleting,
              isUploading,
              selectedAvatarId,
              shopState,
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: _buildStatsColumn(
              l10n,
              statistics,
              selectedThemeId,
              selectedLanguage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormColumn(
    ProfileLocalizations l10n,
    ProfileModel profile,
    bool isSaving,
    bool isDeleting,
    bool isUploading,
    String selectedAvatarId,
    ShopState shopState,
  ) {
    final pendingPath = _viewModel.avatarPreviewPath.value;
    final hasPending = pendingPath != null && pendingPath.isNotEmpty;
    final hasRemote =
        (profile.avatarUrl?.trim().isNotEmpty ?? false) && !hasPending;
    final uploadedAvatarSelected =
        hasPending || (hasRemote && selectedAvatarId == profile.avatarId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProfileTextField(
          label: l10n.profileUsernameLabel,
          controller: _usernameController,
          keyboardType: TextInputType.text,
          maxLength: AuthConstants.usernameMaxLength,
          onChanged: (_) => setState(() {}),
        ),
        _ProfileValidationErrors(errors: _usernameValidationErrors()),
        const SizedBox(height: 16),
        _ProfileTextField(
          label: l10n.profileEmailLabel,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          maxLength: AuthConstants.emailMaxLength,
          onChanged: (_) => setState(() {}),
        ),
        _ProfileValidationErrors(errors: _emailValidationErrors()),
        const SizedBox(height: 16),
        Text(
          l10n.profileAvatarLabel,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
        const SizedBox(height: 8),
        _buildAvatarGrid(
          selectedAvatarId,
          shopState,
          suppressGridSelection: uploadedAvatarSelected,
        ),
        const SizedBox(height: 20),
        _buildAvatarUploadRow(
          l10n,
          profile,
          isSaving || isDeleting || isUploading,
          isSelected: uploadedAvatarSelected,
        ),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: (isSaving || isDeleting || isUploading)
                  ? null
                  : _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    color: context.interactionColors.outline,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                (isSaving || isUploading)
                    ? l10n.profileAvatarUploading
                    : l10n.profileSave,
                style: const TextStyle(
                  fontFamily: 'CustomFont',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: (isSaving || isDeleting || isUploading)
                  ? null
                  : _handleDelete,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.interactionColors.danger,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    color: context.interactionColors.dangerBorder,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                isDeleting ? l10n.profileDeleting : l10n.profileDeleteAccount,
                style: const TextStyle(
                  fontFamily: 'CustomFont',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatarUploadRow(
    ProfileLocalizations l10n,
    ProfileModel profile,
    bool disabled, {
    required bool isSelected,
  }) {
    final pendingPath = _viewModel.avatarPreviewPath.value;
    final hasPending = pendingPath != null && pendingPath.isNotEmpty;
    final hasRemote =
        (profile.avatarUrl?.trim().isNotEmpty ?? false) && !hasPending;
    final resolvedRemote = hasRemote
        ? EnvConfig.resolveAvatarUrl(
            profile.avatarUrl!,
            cacheBust: _avatarRefreshEpoch,
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profileAvatarOrUpload,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'CustomFont',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? context.interactionColors.outline
                      : const Color(0xFF444444),
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.65),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              clipBehavior: Clip.antiAlias,
              child: hasPending
                  ? Image.file(File(pendingPath), fit: BoxFit.cover)
                  : hasRemote
                  ? Image.network(
                      resolvedRemote!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: disabled
                        ? null
                        : () =>
                              unawaited(_pickAvatarImage(ImageSource.gallery)),
                    style: _uploadButtonStyle(),
                    icon: const Icon(Icons.upload_file, size: 18),
                    label: Text(l10n.profileAvatarUploadLabel),
                  ),
                  OutlinedButton.icon(
                    onPressed: disabled
                        ? null
                        : () => unawaited(_pickAvatarImage(ImageSource.camera)),
                    style: _uploadButtonStyle(),
                    icon: const Icon(Icons.photo_camera, size: 18),
                    label: Text(l10n.profileAvatarCameraLabel),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_avatarFileError != null) ...[
          const SizedBox(height: 6),
          Text(
            _avatarFileError!,
            style: const TextStyle(
              color: Color(0xFFE34B4B),
              fontSize: 12,
              fontFamily: 'CustomFont',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildThemeSelector(
    String selectedThemeId,
    ProfileLocalizations l10n,
  ) {
    final themes = [
      ('default', l10n.themeNameDefault, UiAssets.background),
      ('frost', l10n.themeNameFrost, UiAssets.backgroundFrost),
      ('village', l10n.themeNameVillage, UiAssets.backgroundVillage),
    ];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildThemeCard(themes[0], selectedThemeId),
            const SizedBox(width: 10),
            _buildThemeCard(themes[1], selectedThemeId),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildThemeCard(themes[2], selectedThemeId)],
        ),
      ],
    );
  }

  Widget _buildThemeCard((String, String, String) t, String selectedThemeId) {
    final isSelected = selectedThemeId == t.$1;
    return GestureDetector(
      onTap: () {
        _viewModel.setSelectedThemeId(t.$1);
        unawaited(_savePreferences(themeId: t.$1));
      },
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? context.interactionColors.outline
                : const Color(0xFF444444),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Stack(
            children: [
              Image.asset(t.$3, width: 100, height: 70, fit: BoxFit.cover),
              if (isSelected)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: context.interactionColors.outline,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  color: const Color(0xAA000000),
                  child: Text(
                    t.$2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontFamily: 'CustomFont',
                      fontWeight: FontWeight.w600,
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

  Widget _buildLanguageSelector(String selectedLanguage) {
    final languages = [('fr', 'French'), ('en', 'English')];
    return Row(
      children: languages.map((l) {
        final isSelected = selectedLanguage == l.$1;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                _viewModel.setSelectedLanguage(l.$1);
                unawaited(_savePreferences(language: l.$1));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.interactionColors.primary
                      : const Color(0xFF2B2B2B),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected
                        ? context.interactionColors.outline
                        : const Color(0xFF444444),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    l.$2,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontFamily: 'CustomFont',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  bool _isProfileAvatarLocked(AuthAvatar avatar, ShopState shopState) {
    if (!avatar.isExclusiveAtSignUp) return false;
    if (shopState is! ShopStateLoaded) return true;
    final shopItemId = ShopCatalogItemId.values.firstWhere(
      (e) => e.wireValue == avatar.id,
    );
    return !shopState.purchasedItems.contains(shopItemId);
  }

  int _exclusiveAvatarPrice(AuthAvatar avatar, ShopState shopState) {
    const fallback = 500;
    if (!avatar.isExclusiveAtSignUp) return fallback;
    if (shopState is ShopStateLoaded) {
      for (final item in shopState.catalogue) {
        if (item.id.wireValue == avatar.id) return item.price;
      }
    }
    return fallback;
  }

  Widget _buildAvatarGrid(
    String selectedAvatarId,
    ShopState shopState, {
    bool suppressGridSelection = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final outline = context.interactionColors.outline;
    const avatars = AuthAvatar.values;
    const crossAxisCount = 4;
    final rows = <Widget>[];
    for (var i = 0; i < avatars.length; i += crossAxisCount) {
      final rowAvatars = avatars.skip(i).take(crossAxisCount).toList();
      rows.add(
        Row(
          children: rowAvatars.map((AuthAvatar avatar) {
            final id = avatar.id;
            final isSelected = !suppressGridSelection && selectedAvatarId == id;
            final locked = _isProfileAvatarLocked(avatar, shopState);
            final price = _exclusiveAvatarPrice(avatar, shopState);
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: locked
                      ? null
                      : () {
                          setState(() {
                            _avatarFileError = null;
                          });
                          _viewModel.setSelectedAvatarId(id);
                        },
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? outline : const Color(0xFF444444),
                          width: 2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: scheme.primary.withValues(alpha: 0.65),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Opacity(
                              opacity: locked ? 0.45 : 1,
                              child: Image.asset(
                                AuthAvatarAssets.assetPath(avatar),
                                fit: BoxFit.contain,
                              ),
                            ),
                            if (locked)
                              Container(
                                color: Colors.black.withValues(alpha: 0.38),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.lock_rounded,
                                      size: 22,
                                      color: Colors.white.withValues(
                                        alpha: 0.92,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          UiAssets.goldCoin,
                                          width: 18,
                                          height: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '$price',
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.95,
                                            ),
                                            fontFamily: 'CustomFont',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _buildStatsColumn(
    ProfileLocalizations l10n,
    ProfileStatisticsModel stats,
    String selectedThemeId,
    String selectedLanguage,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.profileStatisticsTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'CustomFont',
            ),
          ),
          const SizedBox(height: 20),
          _buildStatCard(
            label: l10n.profileClassicGames,
            value: stats.classicGamesPlayed.toString(),
          ),
          const SizedBox(height: 25),
          _buildStatCard(
            label: l10n.profileCtfGames,
            value: stats.ctfGamesPlayed.toString(),
          ),
          const SizedBox(height: 25),
          _buildStatCard(
            label: l10n.profileGamesWon,
            value: stats.totalGamesWon.toString(),
          ),
          const SizedBox(height: 25),
          _buildStatCard(
            label: l10n.profileAverageTime,
            value: '${stats.averagePlaytimePerGame}s',
          ),
          const SizedBox(height: 8),
          Text(
            l10n.profileThemeLabel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFont',
            ),
          ),
          _buildThemeSelector(selectedThemeId, l10n),
          const SizedBox(height: 16),
          Text(
            l10n.profileLanguageLabel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFont',
            ),
          ),
          const SizedBox(height: 8),
          _buildLanguageSelector(selectedLanguage),
        ],
      ),
    );
  }

  Widget _buildStatCard({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.8),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'CustomFont',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'CustomFont',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave() async {
    final state = _viewModel.state.value;
    if (state is! ProfileStateLoaded) return;
    setState(() {
      _hasAttemptedSave = true;
    });
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final avatarId = _viewModel.selectedAvatarId.value;
    final l10n = ProfileLocalizations.of(context)!;
    final usernameErrors = _usernameValidationErrors();
    final emailErrors = _emailValidationErrors();
    final pendingFilePath = _viewModel.pendingAvatarFilePath.value;
    if (usernameErrors.isNotEmpty || emailErrors.isNotEmpty) {
      return;
    }
    final hasExistingCustomAvatar =
        state.profile.avatarUrl?.trim().isNotEmpty ?? false;
    if (avatarId.isEmpty &&
        pendingFilePath == null &&
        !hasExistingCustomAvatar) {
      _showProfileModal(
        title: l10n.profileErrorTitle,
        description: l10n.profileFillAllFieldsError,
        isError: true,
      );
      return;
    }
    final updateResult = await _viewModel.submitUpdate(
      UpdateProfileCommand(
        username: username,
        email: email,
        avatarId: avatarId.isEmpty ? null : avatarId,
      ),
    );
    if (!mounted) return;
    var canContinue = true;
    updateResult.match((failure) {
      final hasPendingUpload =
          pendingFilePath != null && pendingFilePath.isNotEmpty;
      final onlyNoChanges =
          failure is NoChangesProfileFailure && hasPendingUpload;
      if (!onlyNoChanges) {
        canContinue = false;
        _showProfileModal(
          title: l10n.profileErrorTitle,
          description: failure.localize(l10n),
          isError: true,
        );
      }
    }, (_) {});
    if (!canContinue || !mounted) return;

    if (pendingFilePath != null && pendingFilePath.isNotEmpty) {
      final uploadResult = await _viewModel.uploadAvatar(pendingFilePath);
      if (!mounted) return;
      var uploadFailed = false;
      uploadResult.match(
        (failure) {
          uploadFailed = true;
          _showProfileModal(
            title: l10n.profileErrorTitle,
            description: failure.localize(l10n),
            isError: true,
          );
        },
        (_) {
          _avatarRefreshEpoch = DateTime.now().millisecondsSinceEpoch;
        },
      );
      if (uploadFailed) return;
    }

    final modalKey = DateTime.now().microsecondsSinceEpoch.toString();
    _successModalTimer?.cancel();
    _successModalTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      _dismissSuccessModalIfCurrent(modalKey);
    });
    _showProfileModal(
      title: l10n.profileSuccessTitle,
      description: l10n.profileSaveSuccess,
      isError: false,
      modalKey: modalKey,
      onPrimaryAction: () {
        _successModalTimer?.cancel();
        unawaited(_retryLoad());
      },
    );
  }

  Future<void> _handleDelete() async {
    final l10n = ProfileLocalizations.of(context)!;
    _showProfileModal(
      title: l10n.profileDeleteConfirmTitle,
      description: l10n.profileDeleteConfirmBody,
      isError: true,
      primaryLabel: l10n.profileCancel,
      secondaryLabel: l10n.profileConfirmDelete,
      onSecondaryAction: () => unawaited(_confirmDelete()),
    );
  }

  Future<void> _confirmDelete() async {
    if (!mounted) return;
    final l10n = ProfileLocalizations.of(context)!;
    final result = await _viewModel.deleteAccount();
    if (!mounted) return;
    result.match(
      (failure) => _showProfileModal(
        title: l10n.profileErrorTitle,
        description: failure.localize(l10n),
        isError: true,
      ),
      (_) {},
    );
  }

  Future<void> _savePreferences({String? themeId, String? language}) async {
    final state = _viewModel.state.value;
    if (state is! ProfileStateLoaded) return;
    await _viewModel.submitUpdate(
      UpdateProfileCommand(
        theme: themeId ?? _viewModel.selectedThemeId.value,
        language: language ?? _viewModel.selectedLanguage.value,
      ),
    );
  }
}

class _ProfileTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final int? maxLength;

  const _ProfileTextField({
    required this.label,
    required this.controller,
    required this.keyboardType,
    this.onChanged,
    this.maxLength,
  });

  @override
  State<_ProfileTextField> createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends State<_ProfileTextField> {
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
    final bool isFocused = _focusNode.hasFocus;
    final scheme = Theme.of(context).colorScheme;
    final interaction = context.interactionColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
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
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isFocused
                      ? interaction.focus
                      : interaction.outline.withValues(alpha: 0.45),
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
                          interaction.dangerBorder.withValues(alpha: 0.28),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5],
                      ),
                    ),
                  ),
                ),
              ),
            TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: widget.keyboardType,
              onChanged: widget.onChanged,
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
              style: TextStyle(
                color: scheme.onSurface,
                fontFamily: 'CustomFont',
                fontSize: 18,
              ),
              cursorColor: scheme.primary,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: EdgeInsets.all(12),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileValidationErrors extends StatelessWidget {
  const _ProfileValidationErrors({required this.errors});

  final List<AuthValidationError> errors;

  @override
  Widget build(BuildContext context) {
    if (errors.isEmpty) return const SizedBox.shrink();
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

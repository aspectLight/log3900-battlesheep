import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_interaction_colors.dart';
import '../../../../../core/presentation/widgets/app_background/app_background.dart';
import '../../../../../core/constants/auth_avatar_assets.dart';
import '../../../../../core/enums/auth_avatar.dart';
import '../../../core/localisation/profile_localizations.dart';
import '../../../core/extensions/profile_failure_ext.dart';
import '../../../domain/commands/profile_commands.dart';
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
  late final ProfileViewModel _viewModel;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<ProfileViewModel>();
    unawaited(_init());
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    await _viewModel.load();
    final state = _viewModel.state.value;
    if (state is ProfileStateLoaded) {
      _usernameController.text = state.profile.username;
      _emailController.text = state.profile.email;
      _viewModel.setSelectedAvatarId(state.profile.avatarId);
      _viewModel.syncPreferencesFromProfile(state.profile);
    }
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
                    final isSaving = _viewModel.isSaving.value;
                    final selectedAvatarId = _viewModel.selectedAvatarId.value;
                    _viewModel.selectedThemeId.value;
                    _viewModel.selectedLanguage.value;
                    if (state is ProfileStateLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }
                    return switch (state) {
                      ProfileStateError(:final failure) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(l10n),
                            const SizedBox(height: 24),
                            _buildErrorBanner(failure.localize(l10n)),
                          ],
                        ),
                      ProfileStateLoaded(:final statistics) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(l10n),
                            const SizedBox(height: 24),
                            _buildContent(
                              l10n,
                              statistics,
                              isSaving,
                              selectedAvatarId,
                              _viewModel.selectedThemeId.value,
                              _viewModel.selectedLanguage.value,
                            ),
                          ],
                        ),
                      _ => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(l10n),
                          ],
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

  Widget _buildHeader(ProfileLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => context.router.maybePop(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.chevron_left, color: Colors.white, size: 22),
              const SizedBox(width: 4),
              Text(
              l10n.profileBack,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'CustomFont',
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Text(
          l10n.profileTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: 'CustomFont',
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(width: 60),
      ],
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x33FF0000),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.redAccent),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'CustomFont',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    ProfileLocalizations l10n,
    ProfileStatisticsModel statistics,
    bool isSaving,
    String selectedAvatarId,
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
              isSaving,
              selectedAvatarId,
              selectedThemeId,
              selectedLanguage,
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: _buildStatsColumn(l10n, statistics),
          ),
        ],
      ),
    );
  }

  Widget _buildFormColumn(
    ProfileLocalizations l10n,
    bool isSaving,
    String selectedAvatarId,
    String selectedThemeId,
    String selectedLanguage,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProfileTextField(
          label: l10n.profileUsernameLabel,
          controller: _usernameController,
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 16),
        _ProfileTextField(
          label: l10n.profileEmailLabel,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
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
        _buildAvatarGrid(selectedAvatarId),
        const SizedBox(height: 20),
        Text(
          l10n.profileThemeLabel,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
        const SizedBox(height: 8),
        _buildPreferenceDropdown(
          value: selectedThemeId,
          enabled: !isSaving,
          items: [
            DropdownMenuItem(
              value: 'default',
              child: Text(
                l10n.themeNameDefault,
                style: const TextStyle(fontFamily: 'CustomFont'),
              ),
            ),
            DropdownMenuItem(
              value: 'frost',
              child: Text(
                l10n.themeNameFrost,
                style: const TextStyle(fontFamily: 'CustomFont'),
              ),
            ),
            DropdownMenuItem(
              value: 'village',
              child: Text(
                l10n.themeNameVillage,
                style: const TextStyle(fontFamily: 'CustomFont'),
              ),
            ),
          ],
          onChanged: (v) {
            if (v != null) _viewModel.setSelectedThemeId(v);
          },
        ),
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
        _buildPreferenceDropdown(
          value: selectedLanguage,
          enabled: !isSaving,
          items: [
            DropdownMenuItem(
              value: 'fr',
              child: Text(
                l10n.languageNameFr,
                style: const TextStyle(fontFamily: 'CustomFont'),
              ),
            ),
            DropdownMenuItem(
              value: 'en',
              child: Text(
                l10n.languageNameEn,
                style: const TextStyle(fontFamily: 'CustomFont'),
              ),
            ),
          ],
          onChanged: (v) {
            if (v != null) _viewModel.setSelectedLanguage(v);
          },
        ),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: isSaving ? null : _handleSave,
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
                isSaving ? l10n.profileSaveInProgress : l10n.profileSave,
                style: const TextStyle(
                  fontFamily: 'CustomFont',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: isSaving ? null : _handleDelete,
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
                l10n.profileDeleteAccount,
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

  Widget _buildPreferenceDropdown({
    required String value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?)? onChanged,
    required bool enabled,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: context.interactionColors.outline.withValues(alpha: 0.55),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: scheme.surface,
          style: TextStyle(
            color: scheme.onSurface,
            fontFamily: 'CustomFont',
            fontSize: 16,
          ),
          iconEnabledColor: scheme.onSurface,
          items: items,
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }

  Widget _buildAvatarGrid(String selectedAvatarId) {
    final scheme = Theme.of(context).colorScheme;
    final outline = context.interactionColors.outline;
    const avatars = AuthAvatar.values;
    const crossAxisCount = 4;
    final rows = <Widget>[];
    for (var i = 0; i < avatars.length; i += crossAxisCount) {
      final rowAvatars =
          avatars.skip(i).take(crossAxisCount).toList();
      rows.add(
        Row(
          children: rowAvatars.map((AuthAvatar avatar) {
            final id = avatar.id;
            final isSelected = selectedAvatarId == id;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: () => _viewModel.setSelectedAvatarId(id),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? outline
                              : const Color(0xFF444444),
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
                        child: Image.asset(
                          AuthAvatarAssets.assetPath(avatar),
                          fit: BoxFit.contain,
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
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromRGBO(255, 255, 255, 0.2),
        ),
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
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color.fromRGBO(255, 255, 255, 0.2),
        ),
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
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final avatarId = _viewModel.selectedAvatarId.value;
    if (username.isEmpty || email.isEmpty || avatarId.isEmpty) {
      final l10n = ProfileLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.profileFillAllFieldsError,
            style: const TextStyle(fontFamily: 'CustomFont'),
          ),
        ),
      );
      return;
    }
    await _viewModel.submitUpdate(
      UpdateProfileCommand(
        username: username,
        email: email,
        avatarId: avatarId,
        theme: _viewModel.selectedThemeId.value,
        language: _viewModel.selectedLanguage.value,
      ),
    );
  }

  Future<void> _handleDelete() async {
    await _viewModel.deleteAccount();
  }
}

class _ProfileTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _ProfileTextField({
    required this.label,
    required this.controller,
    required this.keyboardType,
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
            style: TextStyle(
              color: scheme.onSurface,
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


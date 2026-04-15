import 'dart:io';

import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/constants/auth_avatar_assets.dart';
import '../../../../../core/enums/auth_avatar.dart';
import '../../../core/localisation/auth_localizations.dart';
import 'avatar_picker_view_model.dart';

class AvatarPicker extends StatelessWidget {
  const AvatarPicker({
    required this.viewModel,
    required this.onPickFromGallery,
    required this.onPickFromCamera,
    this.error,
    this.customAvatarPath,
    this.customAvatarError,
    this.onSelectionChange,
    super.key,
  });

  final AvatarPickerViewModel viewModel;
  final VoidCallback onPickFromGallery;
  final VoidCallback onPickFromCamera;
  final String? error;
  final String? customAvatarPath;
  final String? customAvatarError;
  final void Function(AuthAvatar)? onSelectionChange;

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
  Widget build(BuildContext context) {
    final l10n = AuthLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.avatarTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'CustomFont',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: viewModel.avatars.length,
          itemBuilder: (context, index) {
            final avatar = viewModel.avatars[index];
            final avatarPath = AuthAvatarAssets.assetPath(avatar);

            return Watch((context) {
              final isSelected = viewModel.isSelected(avatar);
              return GestureDetector(
                onTap: () {
                  viewModel.selectAvatar(avatar);
                  onSelectionChange?.call(avatar);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F0F0F),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFC60D0D)
                          : const Color(0xFF333333),
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image.asset(avatarPath, fit: BoxFit.cover),
                  ),
                ),
              );
            });
          },
        ),
        const SizedBox(height: 12),
        Text(
          l10n.avatarCustomHint,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontFamily: 'CustomFont',
          ),
        ),
        const SizedBox(height: 8),
        if (customAvatarPath != null && customAvatarPath!.isNotEmpty) ...[
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF444444), width: 1.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.file(File(customAvatarPath!), fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: onPickFromGallery,
              style: _uploadButtonStyle(),
              icon: const Icon(Icons.upload_file, size: 18),
              label: Text(l10n.avatarUploadLabel),
            ),
            OutlinedButton.icon(
              onPressed: onPickFromCamera,
              style: _uploadButtonStyle(),
              icon: const Icon(Icons.photo_camera, size: 18),
              label: Text(l10n.avatarCameraLabel),
            ),
          ],
        ),
        if (customAvatarError != null) ...[
          const SizedBox(height: 8),
          Text(
            customAvatarError!,
            style: const TextStyle(
              color: Color(0xFFE34B4B),
              fontSize: 12,
              fontFamily: 'CustomFont',
            ),
          ),
        ],
        if (error != null) ...[
          const SizedBox(height: 12),
          Text(
            error!,
            style: const TextStyle(
              color: Color(0xFFE34B4B),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'CustomFont',
            ),
          ),
        ],
      ],
    );
  }
}

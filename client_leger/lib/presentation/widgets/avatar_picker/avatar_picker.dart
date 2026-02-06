import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../generated/l10n/app_localizations.dart';
import 'avatar_picker_view_model.dart';

class AvatarPicker extends StatelessWidget {
  const AvatarPicker({
    required this.viewModel,
    this.error,
    this.onSelectionChange,
    super.key,
  });

  final AvatarPickerViewModel viewModel;
  final String? error;
  final void Function(String)? onSelectionChange;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
          itemCount: viewModel.avatarIds.length,
          itemBuilder: (context, index) {
            final avatarId = viewModel.avatarIds[index];
            final avatarPath = viewModel.avatarPaths[index];

            return Watch((context) {
              final isSelected = viewModel.selectedAvatarId.value == avatarId;
              return GestureDetector(
                onTap: () {
                  viewModel.selectAvatar(avatarId);
                  onSelectionChange?.call(avatarId);
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

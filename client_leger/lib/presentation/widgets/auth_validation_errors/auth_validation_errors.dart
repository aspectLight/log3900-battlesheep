import 'package:flutter/material.dart';

import '../../../../core/enums/auth_validation_error.dart';
import '../../../../core/l10n/extensions/auth_validation_error_ext.dart';
import '../../../../generated/l10n/app_localizations.dart';

class AuthValidationErrors extends StatelessWidget {
  const AuthValidationErrors({required this.errors, super.key});

  final List<AuthValidationError> errors;

  @override
  Widget build(BuildContext context) {
    if (errors.isEmpty) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;

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

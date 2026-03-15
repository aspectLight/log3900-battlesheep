import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/localisation/core_localizations.dart';
import '../../../../../core/presentation/widgets/app_background/app_background.dart';
import '../widgets/channels_list_widget.dart';
import '../widgets/create_channel_section.dart';
import '../widgets/joined_channels_section.dart';
import 'discussion_canals_view_model.dart';

@RoutePage()
class DiscussionCanalsScreen extends StatefulWidget {
  const DiscussionCanalsScreen({super.key});

  @override
  State<DiscussionCanalsScreen> createState() => _DiscussionCanalsScreenState();
}

class _DiscussionCanalsScreenState extends State<DiscussionCanalsScreen> {
  late final DiscussionCanalsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<DiscussionCanalsViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = CoreLocalizations.of(context)!;
    return AppBackground(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeader(l10n),
            const SizedBox(height: 8),
            Watch((context) => _buildAlerts()),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CreateChannelSection(viewModel: _viewModel),
                    const SizedBox(height: 8),
                    ChannelsListWidget(viewModel: _viewModel),
                    const SizedBox(height: 16),
                    JoinedChannelsSection(viewModel: _viewModel),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(CoreLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: _viewModel.requestLeave,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 18),
                    Text(
                      l10n.homePage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'CustomFont',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Text(
            l10n.discussionCanals,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 44,
              fontFamily: 'CustomFont',
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              shadows: [
                Shadow(
                  color: Color(0x99000000),
                  offset: Offset(0, 3),
                  blurRadius: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlerts() {
    final success = _viewModel.successMessage.value;
    final error = _viewModel.errorMessage.value;
    if (success == null && error == null) return const SizedBox.shrink();
    return Column(
      children: [
        if (success != null) _buildAlert(success, isSuccess: true),
        if (error != null) _buildAlert(error, isSuccess: false),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildAlert(String message, {required bool isSuccess}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: isSuccess ? const Color(0x2632B464) : const Color(0x26C83232),
        border: Border.all(
          color: isSuccess ? const Color(0xFF2e7d52) : const Color(0xFF7f1f1f),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isSuccess ? const Color(0xFFa8f0c8) : const Color(0xFFff9090),
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }
}

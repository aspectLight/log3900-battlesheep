import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_interaction_colors.dart';
import '../../../../../core/localisation/core_localizations.dart';
import '../../../../../core/presentation/shell/shell_chrome_back_handler.dart';
import '../../../../../core/presentation/widgets/app_background/app_background.dart';
import '../../../core/enums/log_type.dart';
import '../../../core/extensions/logs_history_failure_ext.dart';
import '../../../domain/models/logs_history_item.dart';
import '../../../domain/state/logs_history_state.dart';
import 'logs_history_view_model.dart';

@RoutePage()
class LogsHistoryScreen extends StatefulWidget {
  const LogsHistoryScreen({super.key});

  @override
  State<LogsHistoryScreen> createState() => _LogsHistoryScreenState();
}

class _LogsHistoryScreenState extends State<LogsHistoryScreen> {
  static const Color _kBadgeLogin = Color(0xFFc9ffe4);
  static const Color _kBadgeLogout = Color(0xFFfb8585);

  late final LogsHistoryViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<LogsHistoryViewModel>();
    GetIt.I<ShellChromeBackHandler>().register(_viewModel.requestLeave);
    unawaited(_viewModel.loadHistory());
  }

  @override
  void dispose() {
    GetIt.I<ShellChromeBackHandler>().clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = CoreLocalizations.of(context)!;

    return AppBackground(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [Expanded(child: _buildBody(l10n))]),
      ),
    );
  }

  Widget _buildBody(CoreLocalizations l10n) {
    return Watch((context) {
      final s = _viewModel.state.value;
      if (s is LogsHistoryStateLoading) {
        return _buildHistoryListWithState(l10n, l10n.loading);
      }
      if (s is LogsHistoryStateError) {
        return _buildHistoryListWithState(l10n, s.failure.localize(l10n));
      }
      final items = s is LogsHistoryStateLoaded ? s.items : <LogsHistoryItem>[];
      return _buildHistoryList(l10n, items);
    });
  }

  Widget _buildHistoryListWithState(CoreLocalizations l10n, String stateText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTableHeader(l10n, context),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _buildStateBox(stateText),
          ),
        ),
      ],
    );
  }

  Widget _buildStateBox(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.interactionColors.primaryStrong,
        border: Border.all(color: context.interactionColors.outline),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'CustomFont',
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildHistoryList(
    CoreLocalizations l10n,
    List<LogsHistoryItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTableHeader(l10n, context),
        Expanded(
          child: items.isEmpty
              ? _buildStateBox(l10n.noEntries)
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildRow(
                      l10n,
                      item,
                      index,
                      index == items.length - 1,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(CoreLocalizations l10n, BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: context.interactionColors.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        border: Border(
          left: BorderSide(color: context.interactionColors.outline),
          right: BorderSide(color: context.interactionColors.outline),
          top: BorderSide(color: context.interactionColors.outline),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 220,
            child: Text(
              l10n.action.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'CustomFont',
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: Text(
              l10n.date.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'CustomFont',
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: Text(
              l10n.time.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'CustomFont',
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    CoreLocalizations l10n,
    LogsHistoryItem item,
    int index,
    bool isLast,
  ) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm:ss');
    final isLogin = item.type == LogType.login;
    final actionText = isLogin ? l10n.login : l10n.logout;
    final badgeColor = isLogin ? _kBadgeLogin : _kBadgeLogout;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final double opacity = value.clamp(0.0, 1.0);
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, -20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: context.interactionColors.primaryStrong,
          border: Border(
            left: BorderSide(color: context.interactionColors.outline),
            right: BorderSide(color: context.interactionColors.outline),
            bottom: BorderSide(color: context.interactionColors.outline),
          ),
          borderRadius: isLast
              ? const BorderRadius.vertical(bottom: Radius.circular(8))
              : null,
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              offset: Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 220,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: Text(
                    actionText,
                    style: TextStyle(
                      color: badgeColor,
                      fontFamily: 'CustomFont',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                dateFormat.format(item.date),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'CustomFont',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
            ),
            Expanded(
              child: Text(
                timeFormat.format(item.date),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'CustomFont',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

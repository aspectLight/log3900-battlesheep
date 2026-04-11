import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_interaction_colors.dart';
import '../../../../../core/localisation/core_localizations.dart';
import '../../../../../core/presentation/widgets/app_background/app_background.dart';
import '../../../core/enums/game_result.dart';
import '../../../core/extensions/game_history_failure_ext.dart';
import '../../../domain/models/game_history_item.dart';
import '../../../domain/state/game_history_state.dart';
import 'game_history_view_model.dart';

const Color _kBadgeYes = Color(0xFFc9ffe4);
const Color _kBadgeNo = Color(0xFFfb8585);
const Color _kBadgeAbandonedYes = Color(0xFFFFd39a);
const Color _kStateBg = Color(0x40000000);

@RoutePage()
class GameHistoryScreen extends StatefulWidget {
  const GameHistoryScreen({super.key});

  @override
  State<GameHistoryScreen> createState() => _GameHistoryScreenState();
}

class _GameHistoryScreenState extends State<GameHistoryScreen> {
  late final GameHistoryViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<GameHistoryViewModel>();
    unawaited(_viewModel.loadHistory());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = CoreLocalizations.of(context)!;

    return AppBackground(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTopBar(l10n),
            const SizedBox(height: 10),
            Expanded(child: _buildBody(l10n)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(CoreLocalizations l10n) {
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
            l10n.gameHistory,
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

  Widget _buildBody(CoreLocalizations l10n) {
    return Watch((context) {
      final s = _viewModel.state.value;
      if (s is GameHistoryStateLoading) {
        return _buildHistoryListWithState(l10n, l10n.loading);
      }
      if (s is GameHistoryStateError) {
        return _buildHistoryListWithState(l10n, s.failure.localize(l10n));
      }
      final items = s is GameHistoryStateLoaded ? s.items : <GameHistoryItem>[];
      return _buildHistoryList(l10n, items);
    });
  }

  Widget _buildHistoryListWithState(CoreLocalizations l10n, String stateText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTableHeader(l10n),
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
        color: _kStateBg,
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
    List<GameHistoryItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTableHeader(l10n),
        Expanded(
          child: items.isEmpty
              ? _buildStateBox(l10n.noEntries)
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildRow(l10n, item, index == items.length - 1);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(CoreLocalizations l10n) {
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
          Expanded(
            child: Text(
              l10n.result.toUpperCase(),
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
              l10n.abandoned.toUpperCase(),
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

  Color _resultBadgeColor(GameHistoryItem item) {
    return (item.result == GameResult.won) ? _kBadgeYes : _kBadgeNo;
  }

  Color _abandonedBadgeColor(GameHistoryItem item) {
    return (item.result == GameResult.abandoned)
        ? _kBadgeAbandonedYes
        : _kBadgeYes;
  }

  Widget _buildRow(CoreLocalizations l10n, GameHistoryItem item, bool isLast) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm:ss');

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
            Expanded(
              child: Text(
                dateFormat.format(item.startDate),
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
                timeFormat.format(item.startDate),
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
              child: Center(
                child: Text(
                  item.result == GameResult.won ? l10n.won : l10n.lost,
                  style: TextStyle(
                    color: _resultBadgeColor(item),
                    fontFamily: 'CustomFont',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  item.result == GameResult.abandoned ? l10n.yes : l10n.no,
                  style: TextStyle(
                    color: _abandonedBadgeColor(item),
                    fontFamily: 'CustomFont',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

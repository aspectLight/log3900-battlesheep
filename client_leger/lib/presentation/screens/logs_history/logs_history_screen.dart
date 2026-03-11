import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/entities/logs_history_item.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../routing/app_router.dart';
import '../../widgets/app_background/app_background.dart';
import 'logs_history_view_model.dart';

@RoutePage()
class LogsHistoryScreen extends StatefulWidget {
  const LogsHistoryScreen({super.key});

  @override
  State<LogsHistoryScreen> createState() => _LogsHistoryScreenState();
}

class _LogsHistoryScreenState extends State<LogsHistoryScreen> {
  late final LogsHistoryViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<LogsHistoryViewModel>();
    unawaited(_viewModel.loadHistory());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppBackground(
      child: Column(
        children: [
          _buildHeader(l10n),
          Expanded(child: _buildBody(l10n)),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => context.router.push(const MainMenuRoute()),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.leaveGame,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'CustomFont',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              l10n.connectionHistory,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'CustomFont',
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        if (_viewModel.errorMessage != null) {
          return _buildErrorState(_viewModel.errorMessage!);
        }
        return _buildHistoryList(l10n);
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.black26,
          border: Border.all(color: const Color(0xFF3a3a3a)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFFe0d8c0), fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildHistoryList(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildTableHeader(l10n),
          Expanded(
            child: _viewModel.items.isEmpty
                ? _buildEmptyState(l10n)
                : _buildRows(),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF3c3c3c),
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        border: Border(
          left: BorderSide(color: Color(0xFF3a3a3a)),
          right: BorderSide(color: Color(0xFF3a3a3a)),
          top: BorderSide(color: Color(0xFF3a3a3a)),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell(l10n.action),
          _buildHeaderCell(l10n.date),
          _buildHeaderCell(l10n.time),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String label) {
    return Expanded(
      child: Text(
        label.toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFFe0d8c0),
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black26,
        border: Border.all(color: const Color(0xFF3a3a3a)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          l10n.noEntries,
          style: const TextStyle(color: Color(0xFFe0d8c0), fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildRows() {
    return ListView(
      children: _viewModel.items
          .asMap()
          .entries
          .map(
            (entry) => _LogsHistoryRow(
              item: entry.value,
              isLast: entry.key == _viewModel.items.length - 1,
            ),
          )
          .toList(),
    );
  }
}

class _LogsHistoryRow extends StatelessWidget {
  final LogsHistoryItem item;
  final bool isLast;

  const _LogsHistoryRow({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isLogin = item.type == LogType.login;
    final date = item.date;
    final dateStr =
        '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
    final timeStr =
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}:'
        '${date.second.toString().padLeft(2, '0')}';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2b2b2b),
        border: Border.all(color: const Color(0xFF3a3a3a)),
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(8))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                isLogin ? 'Connexion' : 'Déconnexion',
                style: TextStyle(
                  color: isLogin
                      ? const Color(0xFFc9ffe4)
                      : const Color(0xFFfb8585),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                dateStr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                timeStr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

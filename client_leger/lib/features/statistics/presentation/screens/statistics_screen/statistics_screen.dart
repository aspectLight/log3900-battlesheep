import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../core/context/statistics_scope_holder.dart';
import '../../../core/localisation/statistics_localizations.dart';
import '../../../../../core/presentation/widgets/app_background/app_background.dart';
import '../../widgets/statistics_content/statistics_content_widget.dart';
import 'statistics_screen_view_model.dart';

@RoutePage()
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late final StatisticsScreenViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<StatisticsScopeHolder>().scope!
        .get<StatisticsScreenViewModel>();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = StatisticsLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _viewModel.handleBackPressed();
      },
      child: AppBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: _viewModel.handleBackPressed,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      l10n.statisticsReturnHome,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'CustomFont',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leadingWidth: 180,
            title: Text(
              l10n.statisticsTitle,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'CustomFont',
              ),
            ),
            centerTitle: true,
          ),
          body: StatisticsContentWidget(
            viewModel: _viewModel.statisticsViewModel,
          ),
        ),
      ),
    );
  }
}

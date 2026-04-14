import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/notification/notification_intent.dart';
import '../../../../../core/notification/notification_intent_sink.dart';
import '../../../../../core/presentation/widgets/app_background/app_background.dart';
import '../../../core/localisation/shop_localizations.dart';
import '../../../core/exceptions/shop_purchase_exception.dart';
import '../../../domain/models/shop_item_model.dart';
import '../../../domain/state/shop_state.dart';
import '../../widgets/shop_item_card/shop_item_card.dart';
import 'shop_view_model.dart';

const double _shopCardWidth = 180;
const double _shopWrapSpacing = 16;

double _shopColumnWidth(
  double viewportWidth,
  int bannerCount,
  int characterCount,
  int avatarCount,
) {
  const maxCap = 1200.0;
  final cap = math.min(maxCap, viewportWidth);
  final natural = math.max(
    _longestWrapRunWidth(cap, bannerCount),
    math.max(
      _longestWrapRunWidth(cap, characterCount),
      _longestWrapRunWidth(cap, avatarCount),
    ),
  );
  if (natural <= 0) {
    return cap;
  }
  const phantomSlackThreshold = _shopCardWidth + _shopWrapSpacing;
  if (cap - natural > phantomSlackThreshold) {
    return natural;
  }
  return cap;
}

double _longestWrapRunWidth(double maxWidth, int itemCount) {
  if (itemCount <= 0 || maxWidth <= 0) {
    return 0;
  }
  final perRow = math.max(
    1,
    ((maxWidth + _shopWrapSpacing) / (_shopCardWidth + _shopWrapSpacing))
        .floor(),
  );
  var longest = 0.0;
  var remaining = itemCount;
  while (remaining > 0) {
    final inRow = remaining > perRow ? perRow : remaining;
    final w =
        inRow * _shopCardWidth +
        (inRow > 1 ? (inRow - 1) * _shopWrapSpacing : 0);
    if (w > longest) {
      longest = w;
    }
    remaining -= inRow;
  }
  return math.min(longest, maxWidth);
}

@RoutePage()
class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late final ShopViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<ShopViewModel>();
    _viewModel.load();
  }

  void _onBuyPressed(ShopItemModel item, ShopStateLoaded state) {
    if (state.purchasedItems.contains(item.id)) {
      return;
    }
    if (state.balance < item.price) {
      GetIt.I<NotificationIntentSink>().addIntent(
        const ShopPurchaseFailedNotificationIntent(
          InsufficientFundsShopPurchaseException(),
        ),
      );
      return;
    }
    _viewModel.requestPurchase(item);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ShopLocalizations.of(context)!;

    return Watch((context) {
      final state = _viewModel.state.value;

      return AppBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: switch (state) {
                  ShopStateLoading() => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  ShopStateLoaded() => _buildShopBody(l10n, state),
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildShopBody(ShopLocalizations l10n, ShopStateLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boxWidth = _shopColumnWidth(
            constraints.maxWidth,
            _viewModel.banners.length,
            _viewModel.characters.length,
            _viewModel.avatars.length,
          );
          return Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: boxWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(l10n.shopBannersSection),
                  const SizedBox(height: 14),
                  _buildItemWrap(_viewModel.banners, state),
                  const SizedBox(height: 36),
                  _sectionTitle(l10n.shopCharactersSection),
                  const SizedBox(height: 14),
                  _buildItemWrap(_viewModel.characters, state),
                  const SizedBox(height: 36),
                  _sectionTitle(l10n.shopAvatarsSection),
                  const SizedBox(height: 14),
                  _buildItemWrap(_viewModel.avatars, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemWrap(List<ShopItemModel> items, ShopStateLoaded state) {
    return Wrap(
      spacing: _shopWrapSpacing,
      runSpacing: _shopWrapSpacing,
      children: items.map((item) {
        final owned = state.purchasedItems.contains(item.id);
        return ShopItemCard(
          item: item,
          owned: owned,
          onBuy: () => _onBuyPressed(item, state),
        );
      }).toList(),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.start,
      style: const TextStyle(
        color: Color(0xFFE0D8C0),
        fontSize: 22,
        fontFamily: 'CustomFont',
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
        shadows: [
          Shadow(offset: Offset(1, 1), blurRadius: 3, color: Colors.black87),
        ],
      ),
    );
  }
}

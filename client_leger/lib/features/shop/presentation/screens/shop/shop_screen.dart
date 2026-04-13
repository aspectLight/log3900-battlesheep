import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/notification/notification_intent.dart';
import '../../../../../core/notification/notification_intent_sink.dart';
import '../../../../../core/presentation/widgets/app_background/app_background.dart';
import '../../../core/localisation/shop_localizations.dart';
import '../../../core/constants/shop_asset_paths.dart';
import '../../../core/exceptions/shop_purchase_exception.dart';
import '../../../domain/models/shop_item_model.dart';
import '../../../domain/state/shop_state.dart';
import '../../widgets/shop_item_card/shop_item_card.dart';
import 'shop_view_model.dart';

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

  void _onBuyPressed(
    ShopItemModel item,
    ShopStateLoaded state,
  ) {
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
              _buildHeader(context, l10n, state),
              Expanded(
                child: switch (state) {
                  ShopStateLoading() => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  ShopStateLoaded() => _buildShopBody(
                    l10n,
                    state,
                  ),
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeader(
    BuildContext context,
    ShopLocalizations l10n,
    ShopState state,
  ) {
    final balance = state is ShopStateLoaded ? state.balance : 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => context.router.maybePop(),
              icon: Image.asset(
                'assets/images/ui/character_creation_back_arrow.png',
                width: 18,
                height: 18,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
              ),
              label: Text(
                l10n.shopBack,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'CustomFont',
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Text(
            l10n.shopTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'CustomFont',
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: const Color(0xD9160707),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFB71C1C), width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$balance',
                    style: const TextStyle(
                      color: Color(0xFFF0C040),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'CustomFont',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    ShopAssetPaths.coinIcon,
                    width: 26,
                    height: 26,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.monetization_on,
                      color: Color(0xFFF0C040),
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopBody(
    ShopLocalizations l10n,
    ShopStateLoaded state,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _sectionTitle(l10n.shopBannersSection),
              const SizedBox(height: 14),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _viewModel.banners.map((item) {
                  final owned = state.purchasedItems.contains(item.id);
                  return ShopItemCard(
                    item: item,
                    owned: owned,
                    onBuy: () => _onBuyPressed(item, state),
                  );
                }).toList(),
              ),
              const SizedBox(height: 36),
              _sectionTitle(l10n.shopCharactersSection),
              const SizedBox(height: 14),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _viewModel.characters.map((item) {
                  final owned = state.purchasedItems.contains(item.id);
                  return ShopItemCard(
                    item: item,
                    owned: owned,
                    onBuy: () => _onBuyPressed(item, state),
                  );
                }).toList(),
              ),
              const SizedBox(height: 36),
              _sectionTitle(l10n.shopAvatarsSection),
              const SizedBox(height: 14),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _viewModel.avatars.map((item) {
                  final owned = state.purchasedItems.contains(item.id);
                  return ShopItemCard(
                    item: item,
                    owned: owned,
                    onBuy: () => _onBuyPressed(item, state),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFFE0D8C0),
        fontSize: 22,
        fontFamily: 'CustomFont',
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
        shadows: [
          Shadow(
            offset: Offset(1, 1),
            blurRadius: 3,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }
}

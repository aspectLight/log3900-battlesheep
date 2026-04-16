import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/enums/item_type.dart';
import '../../../../../core/helpers/functional_programming.dart';
import '../../ui_models/components/game_player_inventory_slot_ui.dart';
import '../item_card/item_card_widget.dart';
import 'game_player_inventory_view_model.dart';

class GamePlayerInventoryWidget extends StatefulWidget {
  const GamePlayerInventoryWidget({super.key});

  @override
  State<GamePlayerInventoryWidget> createState() =>
      _GamePlayerInventoryWidgetState();
}

class _GamePlayerInventoryWidgetState extends State<GamePlayerInventoryWidget> {
  late final GamePlayerInventoryViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<GamePlayerInventoryViewModel>();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<GamePlayerInventorySlotUi> slots = _viewModel.inventorySlots
        .watch(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: slots
            .asMap()
            .entries
            .map(
              (entry) =>
                  _InventorySlot(slot: entry.value, viewModel: _viewModel),
            )
            .toList(),
      ),
    );
  }
}

class _InventorySlot extends StatelessWidget {
  final GamePlayerInventorySlotUi slot;
  final GamePlayerInventoryViewModel viewModel;

  const _InventorySlot({required this.slot, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final canDropTorch = viewModel.canDropTorch.watch(context);
    final child = slot.item.when(
      none: () => const _EmptySlotPlaceholder(),
      some: (item) => ItemCardWidget(
        item: item,
        showDropButton: item.type == ItemType.torch,
        dropEnabled: canDropTorch,
        onDropPressed: viewModel.dropTorch,
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: child,
    );
  }
}

class _EmptySlotPlaceholder extends StatelessWidget {
  const _EmptySlotPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF444444)),
      ),
    );
  }
}

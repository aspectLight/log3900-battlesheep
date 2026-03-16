import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

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
            .map((entry) => _InventorySlot(slot: entry.value))
            .toList(),
      ),
    );
  }
}

class _InventorySlot extends StatefulWidget {
  final GamePlayerInventorySlotUi slot;

  const _InventorySlot({required this.slot});

  @override
  State<_InventorySlot> createState() => _InventorySlotState();
}

class _InventorySlotState extends State<_InventorySlot> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final child = widget.slot.item.when(
      none: () => const _EmptySlotPlaceholder(),
      some: (item) => ItemCardWidget(item: item),
    );
    final hasItem = widget.slot.item.isSome();
    final isDesktop = kIsWeb ||
        {
          TargetPlatform.windows,
          TargetPlatform.linux,
          TargetPlatform.macOS,
        }.contains(defaultTargetPlatform);

    // Fine‑tuned lift so the card is readable
    // and sits slightly lower than before.
    final yOffset = _isHovered && hasItem ? -95.0 : 0.0;

    Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, yOffset, 0),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: child,
    );

    if (isDesktop) {
      content = MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: content,
      );
    } else {
      content = GestureDetector(
        onTap: hasItem
            ? () => setState(() => _isHovered = !_isHovered)
            : null,
        child: content,
      );
    }

    return content;
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

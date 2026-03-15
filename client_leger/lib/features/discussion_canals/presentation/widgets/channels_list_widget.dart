import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/models/channel_info.dart';
import '../screens/discussion_canals_view_model.dart';
import 'channel_row_widget.dart';

const _kHeaderBg = Color(0xFF3c3c3c);
const _kBorder = Color(0xFF3a3a3a);
const _kHeaderText = Color(0xFFe0d8c0);
const _kStateBg = Color(0x40000000);
const _kPrimary = Color(0xFF8b0000);

class ChannelsListWidget extends StatefulWidget {
  const ChannelsListWidget({super.key, required this.viewModel});

  final DiscussionCanalsViewModel viewModel;

  @override
  State<ChannelsListWidget> createState() => _ChannelsListWidgetState();
}

class _ChannelsListWidgetState extends State<ChannelsListWidget> {
  final _searchController = TextEditingController();
  String _filterTerm = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ChannelInfo> _filtered(List<ChannelInfo> all) {
    final term = _filterTerm.trim().toLowerCase();
    if (term.isEmpty) return all;
    return all.where((c) => c.name.toLowerCase().contains(term)).toList();
  }

  Future<void> _confirmDelete(String channelId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2b2b2b),
        title: const Text(
          'Supprimer le canal',
          style: TextStyle(color: Colors.white, fontFamily: 'CustomFont'),
        ),
        content: const Text(
          'Voulez-vous vraiment supprimer ce canal ?',
          style: TextStyle(color: _kHeaderText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Non',
              style: TextStyle(color: Color(0xFFffb347)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Oui',
              style: TextStyle(color: Color(0xFFff6b6b)),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) widget.viewModel.deleteChannel(channelId);
  }

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final filtered = _filtered(widget.viewModel.channels.value);
      final isLoading = widget.viewModel.isLoading.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CANAUX DISPONIBLES',
            style: TextStyle(
              color: _kHeaderText,
              fontSize: 14,
              fontFamily: 'CustomFont',
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _filterTerm = v),
            style: const TextStyle(color: Color(0xFFF0F0F0)),
            decoration: InputDecoration(
              hintText: 'Rechercher un canal par nom...',
              hintStyle: const TextStyle(color: Color(0xFF666666)),
              filled: true,
              fillColor: const Color(0x66000000),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFF3a1212)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFF3a1212)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: _kPrimary),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (isLoading)
            _buildState('Chargement des canaux...')
          else if (filtered.isEmpty)
            _buildState('Aucun canal ne correspond à la recherche.')
          else
            _buildTable(filtered),
        ],
      );
    });
  }

  Widget _buildTable(List<ChannelInfo> channels) {
    return Column(
      children: [
        _buildHeader(),
        ...channels.asMap().entries.map(
          (e) => ChannelRowWidget(
            channel: e.value,
            isLast: e.key == channels.length - 1,
            isJoined: widget.viewModel.isJoined(e.value.id),
            isCreator: widget.viewModel.isCreator(e.value),
            onJoin: () => widget.viewModel.joinChannel(e.value.id),
            onLeave: () => widget.viewModel.leaveChannel(e.value.id),
            onDelete: () => _confirmDelete(e.value.id),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: const BoxDecoration(
        color: _kHeaderBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        border: Border(
          left: BorderSide(color: _kBorder),
          right: BorderSide(color: _kBorder),
          top: BorderSide(color: _kBorder),
        ),
      ),
      child: const Row(
        children: [
          Expanded(flex: 2, child: _HeaderCell('NOM')),
          Expanded(flex: 2, child: _HeaderCell('CRÉATEUR')),
          Expanded(child: _HeaderCell('MEMBRES')),
          Expanded(
            flex: 2,
            child: _HeaderCell('ACTIONS', align: TextAlign.right),
          ),
        ],
      ),
    );
  }

  Widget _buildState(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _kStateBg,
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: _kHeaderText,
          fontFamily: 'CustomFont',
          fontSize: 16,
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text, {this.align = TextAlign.left});

  final String text;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: const TextStyle(
        color: _kHeaderText,
        fontFamily: 'CustomFont',
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
        fontSize: 14,
      ),
    );
  }
}

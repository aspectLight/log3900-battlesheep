import 'package:flutter/material.dart';

import '../screens/discussion_canals_view_model.dart';

const _kBorder = Color(0xFF3a1212);
const _kSectionBg = Color(0xD91E0A0A);
const _kHeaderText = Color(0xFFe0d8c0);
const _kPrimary = Color(0xFF8b0000);

class CreateChannelSection extends StatefulWidget {
  const CreateChannelSection({super.key, required this.viewModel});

  final DiscussionCanalsViewModel viewModel;

  @override
  State<CreateChannelSection> createState() => _CreateChannelSectionState();
}

class _CreateChannelSectionState extends State<CreateChannelSection> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    widget.viewModel.createChannel(_controller.text.trim());
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _kSectionBg,
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CRÉER UN NOUVEAU CANAL',
            style: TextStyle(
              color: _kHeaderText,
              fontSize: 14,
              fontFamily: 'CustomFont',
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLength: 50,
                  style: const TextStyle(color: Color(0xFFF0F0F0)),
                  decoration: InputDecoration(
                    hintText: 'Nom du canal (ex: ABC)',
                    hintStyle: const TextStyle(color: Color(0xFF666666)),
                    counterText: '',
                    filled: true,
                    fillColor: const Color(0x66000000),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: _kBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: _kBorder),
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
                  onSubmitted: (_) => _submit(),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Créer',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

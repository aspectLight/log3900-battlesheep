import 'package:signals_flutter/signals_flutter.dart';

import '../../presentation/view_models/auth_view_model.dart';
import '../entities/auth_state.dart';
import '../interfaces/services/chat_service.dart';

class ChatConnectionManager {
  final ChatService _chatService;
  final AuthViewModel _authViewModel;

  late final EffectCleanup _authEffect;

  ChatConnectionManager({
    required ChatService chatService,
    required AuthViewModel authViewModel,
  }) : _chatService = chatService,
       _authViewModel = authViewModel {
    _setupAuthEffect();
  }

  void _setupAuthEffect() {
    _authEffect = effect(() {
      final state = _authViewModel.authState.value;

      if (state is AuthStateAuthenticated) {
        _chatService.joinGeneralChat(state.user.username);
      } else if (state is AuthStateUnauthenticated || state is AuthStateError) {
        _chatService.leaveGeneralChat();
      }
    });
  }

  void dispose() {
    _authEffect();
  }
}

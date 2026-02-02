import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/entities/auth_state.dart';
import '../../domain/interfaces/services/chat_service.dart';
import './auth_view_model.dart';

class ChatConnectionViewModel {
  final ChatService _generalChatService;
  final AuthViewModel _authViewModel;

  late final EffectCleanup _authEffect;

  ChatConnectionViewModel({
    required ChatService generalChatService,
    required AuthViewModel authViewModel,
  }) : _generalChatService = generalChatService,
       _authViewModel = authViewModel {
    _setupAuthEffect();
  }

  void _setupAuthEffect() {
    _authEffect = effect(() {
      final state = _authViewModel.authState.value;

      if (state is AuthStateAuthenticated) {
        _generalChatService.joinGeneralChat(state.user.username);
      } else if (state is AuthStateUnauthenticated || state is AuthStateError) {
        _generalChatService.leaveGeneralChat();
      }
    });
  }

  void dispose() {
    _authEffect();
  }
}

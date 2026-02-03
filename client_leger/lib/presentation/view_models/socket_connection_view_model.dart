import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/entities/auth_state.dart';
import '../../domain/interfaces/repositories/chat_repository.dart';
import '../../domain/interfaces/services/socket_connection_service.dart';
import './auth_view_model.dart';

class SocketConnectionViewModel {
  final SocketConnectionService _connectionService;
  final AuthViewModel _authViewModel;
  final ChatRepository _chatRepository; // Add this

  late final EffectCleanup _authEffect;

  SocketConnectionViewModel({
    required SocketConnectionService connectionService,
    required AuthViewModel authViewModel,
    required ChatRepository chatRepository,
  }) : _connectionService = connectionService,
       _authViewModel = authViewModel,
       _chatRepository = chatRepository {
    _setupAuthEffect();
  }

  void _setupAuthEffect() {
    _authEffect = effect(() {
      final state = _authViewModel.authState.value;

      if (state is AuthStateAuthenticated) {
        final username = state.user.username;
        _connectionService.connect(username);
        _chatRepository.connect(username); // Add this - sync the username
      } else if (state is AuthStateUnauthenticated || state is AuthStateError) {
        _connectionService.disconnect();
        _chatRepository.disconnect(); // Add this - clean up on logout
      }
    });
  }

  void dispose() {
    _authEffect();
  }
}

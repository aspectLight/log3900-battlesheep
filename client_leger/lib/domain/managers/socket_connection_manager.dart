import 'package:signals_flutter/signals_flutter.dart';

import '../../presentation/view_models/auth_view_model.dart';
import '../entities/auth_state.dart';
import '../interfaces/services/socket_connection_service.dart';

class SocketConnectionManager {
  final SocketConnectionService _connectionService;
  final AuthViewModel _authViewModel;

  late final EffectCleanup _authEffect;

  SocketConnectionManager({
    required SocketConnectionService connectionService,
    required AuthViewModel authViewModel,
  }) : _connectionService = connectionService,
       _authViewModel = authViewModel {
    _setupAuthEffect();
  }

  void _setupAuthEffect() {
    _authEffect = effect(() {
      final state = _authViewModel.authState.value;

      if (state is AuthStateAuthenticated) {
        _connectionService.connect(state.user.username);
      } else if (state is AuthStateUnauthenticated || state is AuthStateError) {
        _connectionService.disconnect();
      }
    });
  }

  void dispose() {
    _authEffect();
  }
}

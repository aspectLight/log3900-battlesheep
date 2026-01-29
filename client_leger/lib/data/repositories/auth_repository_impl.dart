import 'dart:async';
import 'package:fpdart/fpdart.dart';

import '../../core/exceptions/auth_exception.dart';
import '../../data/models/user_dto.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/interfaces/auth_local_service.dart';
import '../../domain/interfaces/auth_repository.dart';
import '../../domain/interfaces/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final AuthLocalService _localService;
  final _authStateController = StreamController<UserEntity?>.broadcast();

  UserEntity? _currentUser;

  AuthRepositoryImpl({
    required AuthService authService,
    required AuthLocalService localService,
  }) : _authService = authService,
       _localService = localService;

  @override
  Stream<UserEntity?> get authStateChanges => _authStateController.stream;

  @override
  Future<UserEntity?> get currentUser async {
    if (_currentUser != null) return _currentUser;

    final localUserDto = await _localService.getUser();
    if (localUserDto != null) {
      _updateState(localUserDto.toEntity());
    }

    final result = await _authService.getCurrentUser().run();

    return result.fold(
      (error) {
        if (localUserDto != null) {
          if (error is InvalidCredentialsException ||
              error is UserNotFoundException) {
            unawaited(_clearLocalUser());
            _updateState(null);
            return null;
          }
          return localUserDto.toEntity();
        }
        return null;
      },
      (serverDto) {
        unawaited(_saveUserToLocal(serverDto));
        final user = serverDto.toEntity();
        _updateState(user);
        return user;
      },
    );
  }

  @override
  TaskEither<AuthException, UserEntity> signIn({
    required String identifier,
    required String password,
  }) {
    return _authService
        .signIn(identifier: identifier, password: password)
        .chainFirst(
          (dto) => TaskEither.tryCatch(
            () => _saveUserToLocal(dto),
            (e, s) => const UnknownAuthException('Failed to save user'),
          ),
        )
        .map((dto) => dto.toEntity())
        .chainFirst((user) {
          _updateState(user);
          return TaskEither.right(unit);
        });
  }

  @override
  TaskEither<AuthException, UserEntity> signUp({
    required String username,
    required String email,
    required String password,
  }) {
    return _authService
        .signUp(username: username, email: email, password: password)
        .chainFirst(
          (dto) => TaskEither.tryCatch(
            () => _saveUserToLocal(dto),
            (e, s) => const UnknownAuthException('Failed to save user'),
          ),
        )
        .map((dto) => dto.toEntity())
        .chainFirst((user) {
          _updateState(user);
          return TaskEither.right(unit);
        });
  }

  @override
  TaskEither<AuthException, Unit> signOut() {
    return _authService.signOut().chainFirst(
      (_) => TaskEither.tryCatch(() async {
        await _clearLocalUser();
        _updateState(null);
        return unit;
      }, (e, s) => const UnknownAuthException('Failed to clear local user')),
    );
  }

  @override
  TaskEither<AuthException, UserEntity> updateProfile({
    String? username,
    String? email,
    String? avatarId,
  }) {
    final updates = <String, dynamic>{};
    if (username != null) updates['username'] = username;
    if (email != null) updates['email'] = email;
    if (avatarId != null) updates['avatarId'] = avatarId;

    return _authService
        .updateProfile(updates)
        .chainFirst(
          (dto) => TaskEither.tryCatch(
            () => _saveUserToLocal(dto),
            (e, s) => const UnknownAuthException('Failed to save user'),
          ),
        )
        .map((dto) => dto.toEntity())
        .chainFirst((user) {
          _updateState(user);
          return TaskEither.right(unit);
        });
  }

  @override
  TaskEither<AuthException, Unit> deleteAccount() {
    return _authService.deleteAccount().chainFirst(
      (_) => TaskEither.tryCatch(() async {
        await _clearLocalUser();
        _updateState(null);
        return unit;
      }, (e, s) => const UnknownAuthException('Failed to clear local user')),
    );
  }

  void _updateState(UserEntity? user) {
    _currentUser = user;
    _authStateController.add(user);
  }

  Future<void> _saveUserToLocal(UserDto user) async {
    await _localService.saveUser(user);
  }

  Future<void> _clearLocalUser() async {
    await _localService.clearAll();
  }
}

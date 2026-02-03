import 'dart:async';
import 'package:fpdart/fpdart.dart';

import '../../core/exceptions/auth_exception.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/interfaces/repositories/auth_repository.dart';
import '../../domain/interfaces/services/auth_local_service.dart';
import '../../domain/interfaces/services/auth_service.dart';
import '../../domain/interfaces/services/firebase_auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final AuthLocalService _localService;
  final FirebaseAuthService _firebaseAuthService;
  final _authStateController = StreamController<UserEntity?>.broadcast();

  UserEntity? _currentUser;

  AuthRepositoryImpl({
    required AuthService authService,
    required AuthLocalService localService,
    required FirebaseAuthService firebaseAuthService,
  }) : _authService = authService,
       _localService = localService,
       _firebaseAuthService = firebaseAuthService;

  @override
  Stream<UserEntity?> get authStateChanges => _authStateController.stream;

  @override
  TaskEither<AuthException, Option<UserEntity>> getCurrentUser() {
    return TaskEither.tryCatch(
      () async {
        if (_currentUser != null) return some(_currentUser!);

        final localUserRes = await _localService.getUser().run();
        final localUserDto = localUserRes.getOrElse((_) => none()).toNullable();

        if (localUserDto != null) {
          _updateState(localUserDto.toEntity());
        }

        final result = await _authService.getCurrentUser().run();

        return result.fold(
          (error) async {
            if (localUserDto != null) {
              if (error is InvalidCredentialsException ||
                  error is UserNotFoundException) {
                await _localService.clearAll().run();
                _updateState(null);
                return none();
              }
              return some(localUserDto.toEntity());
            }
            return none();
          },
          (serverDto) async {
            await _localService.saveUser(serverDto).run();
            final user = serverDto.toEntity();
            _updateState(user);
            return some(user);
          },
        );
      },
      (error, stack) {
        if (error is AuthException) return error;
        return UnknownAuthException(error.toString());
      },
    );
  }

  @override
  TaskEither<AuthException, UserEntity> signIn({
    required String username,
    required String password,
  }) {
    return TaskEither.tryCatch(
      () async {
        final emailRes = await _authService.getEmailByUsername(username).run();
        final email = emailRes.getOrElse((l) => throw l);

        final firebaseResult = await _firebaseAuthService
            .signInWithEmailPassword(email: email, password: password)
            .run();

        final firebaseAuthResponse = firebaseResult.getOrElse((l) => throw l);

        final apiResult = await _authService
            .signInWithToken(firebaseToken: firebaseAuthResponse.idToken)
            .run();

        final userDto = apiResult.getOrElse((l) => throw l);

        await _localService.saveUser(userDto).run();
        final userEntity = userDto.toEntity();
        _updateState(userEntity);

        return userEntity;
      },
      (error, stack) {
        if (error is AuthException) return error;
        return UnknownAuthException(error.toString());
      },
    );
  }

  @override
  TaskEither<AuthException, UserEntity> signUp({
    required String username,
    required String email,
    required String password,
    required String avatarId,
  }) {
    return TaskEither.tryCatch(
      () async {
        final signUpResult = await _authService
            .signUp(
              username: username,
              email: email,
              password: password,
              avatarId: avatarId,
            )
            .run();

        if (signUpResult.isLeft()) {
          throw signUpResult.getLeft().toNullable()!;
        }

        final signInResult = await signIn(
          username: username,
          password: password,
        ).run();

        return signInResult.getOrElse((l) => throw l);
      },
      (error, stack) {
        if (error is AuthException) return error;
        return UnknownAuthException(error.toString());
      },
    );
  }

  @override
  TaskEither<AuthException, Unit> signOut() {
    return TaskEither.tryCatch(
      () async {
        final result = await _authService.signOut().run();
        if (result.isLeft()) throw result.getLeft().toNullable()!;

        await _localService.clearAll().run();
        _updateState(null);
        return unit;
      },
      (error, stack) {
        if (error is AuthException) return error;
        return UnknownAuthException(error.toString());
      },
    );
  }

  @override
  TaskEither<AuthException, UserEntity> updateProfile({
    String? username,
    String? email,
    String? avatarId,
  }) {
    return TaskEither.tryCatch(
      () async {
        final updates = <String, dynamic>{};
        if (username != null) updates['username'] = username;
        if (email != null) updates['email'] = email;
        if (avatarId != null) updates['avatarId'] = avatarId;

        final result = await _authService.updateProfile(updates).run();
        final userDto = result.getOrElse((l) => throw l);

        await _localService.saveUser(userDto).run();
        final userEntity = userDto.toEntity();
        _updateState(userEntity);

        return userEntity;
      },
      (error, stack) {
        if (error is AuthException) return error;
        return UnknownAuthException(error.toString());
      },
    );
  }

  @override
  TaskEither<AuthException, Unit> deleteAccount() {
    return TaskEither.tryCatch(
      () async {
        final result = await _authService.deleteAccount().run();
        if (result.isLeft()) throw result.getLeft().toNullable()!;

        await _localService.clearAll().run();
        _updateState(null);
        return unit;
      },
      (error, stack) {
        if (error is AuthException) return error;
        return UnknownAuthException(error.toString());
      },
    );
  }

  void _updateState(UserEntity? user) {
    _currentUser = user;
    _authStateController.add(user);
  }
}

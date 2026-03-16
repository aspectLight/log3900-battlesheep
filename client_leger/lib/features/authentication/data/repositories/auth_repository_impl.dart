import 'dart:async';

import 'package:fpdart/fpdart.dart';

import '../../../../core/helpers/functional_programming.dart';
import '../../core/exceptions/auth_exception.dart';
import '../../domain/commands/auth_commands.dart';
import '../../domain/models/socket_auth_credentials.dart';
import '../../domain/models/user.dart';
import '../../domain/models/auth_credentials.dart';
import '../services/firebase_auth_service.dart';
import '../services/http_auth_service.dart';
import '../../core/interfaces/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final HttpAuthService _authService;
  final FirebaseAuthService _firebaseAuthService;
  final _authStateController = StreamController<Option<UserModel>>.broadcast();

  Option<UserModel> _currentUser = const Option.none();
  Option<AuthCredentialsModel> _credentials = const Option.none();

  AuthRepositoryImpl({
    required HttpAuthService authService,
    required FirebaseAuthService firebaseAuthService,
  })  : _authService = authService,
        _firebaseAuthService = firebaseAuthService;

  @override
  Stream<Option<UserModel>> get authStateChanges =>
      _authStateController.stream;

  bool get _hasCredentials => _credentials.isSome();

  @override
  Option<SocketAuthCredentialsModel> getSocketAuthCredentials() {
    return _credentials.map(
      (creds) => SocketAuthCredentialsModel(
        token: creds.apiToken,
        sessionId: creds.apiSessionId,
      ),
    );
  }

  void _clearCredentials() {
    _credentials = const Option.none();
  }

  @override
  TaskEither<AuthException, Option<UserModel>> getCurrentUser() {
    return TaskEither.tryCatch(
      () async {
        switch (_currentUser) {
          case Some(value: final user):
            return some(user);
          case None():
            if (!_hasCredentials) return const Option.none();
            final creds = _credentials.assumePresent();
            final result = await _authService
                .getCurrentUser(
                  apiToken: creds.apiToken,
                  apiSessionId: creds.apiSessionId,
                )
                .run();
            return switch (result) {
              Left() => const Option.none(),
              Right(value: final user) => some(user),
            };
        }
      },
      (error, stack) {
        if (error is AuthException) return error;
        return UnknownAuthException(error.toString());
      },
    );
  }

  @override
  TaskEither<AuthException, UserModel> signIn(SignInCommand command) {
    return TaskEither.tryCatch(
      () async {
        final emailRes = await _authService
            .getEmailByUsername(command.username)
            .run();
        final email = switch (emailRes) {
          Left(value: final e) => throw e,
          Right(value: final v) => v,
        };
        final firebaseResult = await _firebaseAuthService
            .signInWithEmailPassword(email: email, password: command.password)
            .run();
        final firebaseSignInResult = switch (firebaseResult) {
          Left(value: final e) => throw e,
          Right(value: final v) => v,
        };
        final apiResult = await _authService
            .signInWithToken(firebaseToken: firebaseSignInResult.idToken)
            .run();
        final signInResult = switch (apiResult) {
          Left(value: final e) => throw e,
          Right(value: final v) => v,
        };
        _credentials = Option.of(
          AuthCredentialsModel(
            apiToken: signInResult.apiToken,
            apiSessionId: signInResult.apiSessionId,
          ),
        );
        _updateState(Option.of(signInResult.user));
        return signInResult.user;
      },
      (error, stack) {
        if (error is AuthException) return error;
        return UnknownAuthException(error.toString());
      },
    );
  }

  @override
  TaskEither<AuthException, UserModel> signUp(SignUpCommand command) {
    return TaskEither.tryCatch(
      () async {
        final signUpResult = await _authService
            .signUp(
              username: command.username,
              email: command.email,
              password: command.password,
              avatarId: command.avatarId,
            )
            .run();
        switch (signUpResult) {
          case Left(value: final e):
            throw e;
          case Right():
            break;
        }
        final signInResult = await signIn(
          SignInCommand(username: command.username, password: command.password),
        ).run();
        return switch (signInResult) {
          Left(value: final e) => throw e,
          Right(value: final user) => user,
        };
      },
      (error, stack) {
        if (error is AuthException) return error;
        return UnknownAuthException(error.toString());
      },
    );
  }

  @override
  TaskEither<AuthException, Unit> signOut(SignOutCommand command) {
    return TaskEither.tryCatch(
      () async {
        if (_hasCredentials) {
          final creds = _credentials.assumePresent();
          final result = await _authService
              .signOut(
                apiToken: creds.apiToken,
                apiSessionId: creds.apiSessionId,
              )
              .run();
          switch (result) {
            case Left(value: final e):
              throw e;
            case Right():
              break;
          }
        }
        _clearCredentials();
        _clearCurrentUser();
        return unit;
      },
      (error, stack) {
        if (error is AuthException) return error;
        return UnknownAuthException(error.toString());
      },
    );
  }

  @override
  TaskEither<AuthException, UserModel> updateProfile(
    UpdateProfileCommand command,
  ) {
    return TaskEither.tryCatch(
      () async {
        if (!_hasCredentials) throw const InvalidCredentialsException();
        final creds = _credentials.assumePresent();
        final result = await _authService
            .updateProfile(
              username: command.username,
              email: command.email,
              avatarId: command.avatarId,
              apiToken: creds.apiToken,
              apiSessionId: creds.apiSessionId,
            )
            .run();
        final user = switch (result) {
          Left(value: final e) => throw e,
          Right(value: final u) => u,
        };
        _updateState(Option.of(user));
        return user;
      },
      (error, stack) {
        if (error is AuthException) return error;
        return UnknownAuthException(error.toString());
      },
    );
  }

  @override
  TaskEither<AuthException, Unit> deleteAccount(DeleteAccountCommand command) {
    return TaskEither.tryCatch(
      () async {
        if (_hasCredentials) {
          final creds = _credentials.assumePresent();
          final result = await _authService
              .deleteAccount(
                apiToken: creds.apiToken,
                apiSessionId: creds.apiSessionId,
              )
              .run();
          switch (result) {
            case Left(value: final e):
              throw e;
            case Right():
              break;
          }
        }
        _clearCredentials();
        return unit;
      },
      (error, stack) {
        if (error is AuthException) return error;
        return UnknownAuthException(error.toString());
      },
    );
  }

  void _updateState(Option<UserModel> user) {
    _currentUser = user;
    _authStateController.add(user);
  }

  void _clearCurrentUser() {
    _updateState(const Option.none());
  }

  void dispose() {
    unawaited(_authStateController.close());
  }
}

import 'package:fpdart/fpdart.dart';

import '../../core/exceptions/auth_exception.dart';
import '../../domain/commands/auth_commands.dart';
import '../../domain/models/socket_auth_credentials.dart';
import '../../domain/models/user.dart';
import '../constants/mock_auth_user.dart';
import '../../core/interfaces/auth_repository.dart';

class FakeAuthRepository extends AuthRepository {
  FakeAuthRepository({UserModel? user}) : _user = user ?? mockAuthUser;

  final UserModel _user;

  @override
  Stream<Option<UserModel>> get authStateChanges => Stream.value(some(_user));

  @override
  void syncCurrentUser(UserModel user) {}

  @override
  Option<SocketAuthCredentialsModel> getSocketAuthCredentials() =>
      const Option.none();

  @override
  TaskEither<AuthException, Option<UserModel>> getCurrentUser() =>
      TaskEither.of(some(_user));

  @override
  TaskEither<AuthException, UserModel> signIn(SignInCommand command) =>
      TaskEither.of(_user);

  @override
  TaskEither<AuthException, UserModel> signUp(SignUpCommand command) =>
      TaskEither.of(_user);

  @override
  TaskEither<AuthException, Unit> signOut(SignOutCommand command) =>
      TaskEither.of(unit);

  @override
  TaskEither<AuthException, UserModel> updateProfile(
    UpdateProfileCommand command,
  ) => TaskEither.of(_user);

  @override
  TaskEither<AuthException, Unit> deleteAccount(DeleteAccountCommand command) =>
      TaskEither.of(unit);
}

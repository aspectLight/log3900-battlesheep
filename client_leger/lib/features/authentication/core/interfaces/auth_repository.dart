import 'package:fpdart/fpdart.dart';

import '../../domain/commands/auth_commands.dart';
import '../../domain/models/socket_auth_credentials.dart';
import '../../domain/models/user.dart';
import '../exceptions/auth_exception.dart';

abstract class AuthRepository {
  Stream<Option<UserModel>> get authStateChanges;

  Option<SocketAuthCredentialsModel> getSocketAuthCredentials();

  TaskEither<AuthException, Option<UserModel>> getCurrentUser();

  TaskEither<AuthException, UserModel> signIn(SignInCommand command);

  TaskEither<AuthException, UserModel> signUp(SignUpCommand command);

  TaskEither<AuthException, Unit> signOut(SignOutCommand command);

  TaskEither<AuthException, UserModel> updateProfile(UpdateProfileCommand command);

  TaskEither<AuthException, Unit> deleteAccount(DeleteAccountCommand command);
}

import 'package:fpdart/fpdart.dart';

import '../../core/exceptions/auth_exception.dart';
import '../../core/interfaces/auth_repository.dart';
import '../commands/auth_commands.dart';
import '../models/user.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  TaskEither<AuthException, UserModel> execute(SignInCommand command) {
    return _authRepository.signIn(command);
  }
}

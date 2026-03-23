import 'package:fpdart/fpdart.dart';

import '../../core/exceptions/auth_exception.dart';
import '../../core/interfaces/auth_repository.dart';
import '../commands/auth_commands.dart';
import '../models/user.dart';

class SignUpUseCase {
  final AuthRepository _authRepository;

  SignUpUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  TaskEither<AuthException, UserModel> execute(SignUpCommand command) {
    return _authRepository.signUp(command);
  }
}


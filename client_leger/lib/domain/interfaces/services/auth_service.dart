import 'package:fpdart/fpdart.dart';
import '../../../core/exceptions/auth_exception.dart';
import '../../../data/models/user_dto.dart';

abstract interface class AuthService {
  TaskEither<AuthException, UserDto> signInWithToken({
    required String firebaseToken,
  });

  TaskEither<AuthException, String> getEmailByUsername(String username);

  TaskEither<AuthException, UserDto> signUp({
    required String username,
    required String email,
    required String password,
    required String avatarId,
  });

  TaskEither<AuthException, UserDto> getCurrentUser();

  TaskEither<AuthException, UserDto> updateProfile(
    Map<String, dynamic> updates,
  );

  TaskEither<AuthException, Unit> signOut();

  TaskEither<AuthException, Unit> deleteAccount();
}

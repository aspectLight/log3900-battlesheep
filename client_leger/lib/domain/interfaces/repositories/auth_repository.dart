import 'package:fpdart/fpdart.dart';
import '../../../core/exceptions/auth_exception.dart';
import '../../entities/user_entity.dart';

abstract interface class AuthRepository {
  Stream<UserEntity?> get authStateChanges;

  TaskEither<AuthException, Option<UserEntity>> getCurrentUser();

  TaskEither<AuthException, UserEntity> signIn({
    required String username,
    required String password,
  });

  TaskEither<AuthException, UserEntity> signUp({
    required String username,
    required String email,
    required String password,
    required String avatarId,
  });

  TaskEither<AuthException, Unit> signOut();

  TaskEither<AuthException, UserEntity> updateProfile({
    String? username,
    String? email,
    String? avatarId,
  });

  TaskEither<AuthException, Unit> deleteAccount();
}

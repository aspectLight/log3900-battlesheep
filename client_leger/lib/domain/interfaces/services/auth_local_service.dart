import 'package:fpdart/fpdart.dart';
import '../../../data/models/user_dto.dart';

abstract interface class AuthLocalService {
  TaskEither<Exception, Unit> saveUser(UserDto user);
  TaskEither<Exception, Option<UserDto>> getUser();
  TaskEither<Exception, Unit> deleteUser();

  TaskEither<Exception, Unit> saveToken(String token);
  TaskEither<Exception, Option<String>> getToken();
  TaskEither<Exception, Unit> deleteToken();

  TaskEither<Exception, Unit> saveSessionId(String sessionId);
  TaskEither<Exception, Option<String>> getSessionId();
  TaskEither<Exception, Unit> deleteSessionId();

  TaskEither<Exception, Unit> clearAll();
}

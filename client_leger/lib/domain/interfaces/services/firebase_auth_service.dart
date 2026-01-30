import 'package:fpdart/fpdart.dart';
import '../../../core/exceptions/auth_exception.dart';
import '../../../data/models/firebase_auth_response.dart';

abstract interface class FirebaseAuthService {
  TaskEither<AuthException, FirebaseAuthResponse> signInWithEmailPassword({
    required String email,
    required String password,
  });
}

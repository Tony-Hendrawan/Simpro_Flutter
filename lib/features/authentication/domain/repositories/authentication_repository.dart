import 'package:fpdart/fpdart.dart';
import '../entities/authentication.dart';

abstract interface class AuthenticationRepository {
  Future<Either<String, Authentication>> loginWithUsernamePassword({
    required String username,
    required String password,
  });

  Future<void> logout();

  Future<Authentication?> getCurrentUser();
}

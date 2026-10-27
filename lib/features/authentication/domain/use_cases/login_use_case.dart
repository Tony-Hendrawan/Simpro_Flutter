import 'package:fpdart/fpdart.dart';
import '../entities/authentication.dart';
import '../repositories/authentication_repository.dart';

class LoginUseCase {
  final AuthenticationRepository repository;

  const LoginUseCase(this.repository);

  Future<Either<String, Authentication>> call({
    required String username,
    required String password,
  }) async {
    return repository.loginWithUsernamePassword(
      username: username,
      password: password,
    );
  }
}

import '../models/authentication_model.dart';

abstract interface class AuthenticationLocalDataSource {
  Future<AuthenticationModel> loginWithUsernamePassword({
    required String username,
    required String password,
  });
}
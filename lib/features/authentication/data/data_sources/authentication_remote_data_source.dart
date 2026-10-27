import '../models/authentication_model.dart';

abstract interface class AuthenticationRemoteDataSource {
  Future<AuthenticationModel> loginWithUsernamePassword({
    required String username,
    required String password,
  });
}
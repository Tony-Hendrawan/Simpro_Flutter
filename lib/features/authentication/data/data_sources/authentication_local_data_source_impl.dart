import '../models/authentication_model.dart';
import 'authentication_local_data_source.dart';

class AuthenticationLocalDataSourceImpl
    implements AuthenticationLocalDataSource {
  static const String _mockUsername = 'admin';
  static const String _mockPassword = 'admin';

  const AuthenticationLocalDataSourceImpl();

  @override
  Future<AuthenticationModel> loginWithUsernamePassword({
    required String username,
    required String password,
  }) async {
    // Simulasi jaringan agar terasa asli saat development
    await Future.delayed(const Duration(milliseconds: 600));

    if (username == _mockUsername && password == _mockPassword) {
      return const AuthenticationModel(
        id: 1,
        name: 'Administrator',
        username: 'admin',
        email: 'admin@simpro.local',
        role: 'admin',
        token: 'mock_token_admin_001',
      );
    }

    throw 'Username atau kata sandi salah.';
  }
}
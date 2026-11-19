import '../models/authentication_model.dart';
import 'authentication_local_data_source.dart';

class AuthenticationLocalDataSourceImpl
    implements AuthenticationLocalDataSource {
  static const String _mockPassword = 'password';

  static const _mockUsers = {
    'owner': (
      id: 1,
      name: 'Ir. H. Hendra Wijaya',
      email: 'owner@arthamasgraha.com',
      role: 'owner',
    ),
    'admin': (
      id: 2,
      name: 'Admin Sistem',
      email: 'admin@arthamasgraha.com',
      role: 'admin',
    ),
    'pengawas': (
      id: 3,
      name: 'Andi Wijaya, ST',
      email: 'pengawas.lapangan@arthamasgraha.com',
      role: 'pengawas',
    ),
    'logistik': (
      id: 4,
      name: 'Agus Setiawan',
      email: 'gudang.logistik@arthamasgraha.com',
      role: 'logistik',
    ),
    'keuangan': (
      id: 5,
      name: 'Ratna Sari, SE',
      email: 'finance@arthamasgraha.com',
      role: 'keuangan',
    ),
  };

  const AuthenticationLocalDataSourceImpl();

  @override
  Future<AuthenticationModel> loginWithUsernamePassword({
    required String username,
    required String password,
  }) async {
    // Simulasi jaringan agar terasa asli saat development
    await Future.delayed(const Duration(milliseconds: 600));

    final user = _mockUsers[username.toLowerCase()];
    if (user != null && password == _mockPassword) {
      return AuthenticationModel(
        id: user.id,
        name: user.name,
        username: username.toLowerCase(),
        email: user.email,
        role: user.role,
        token: 'mock_token_${user.role}',
      );
    }

    throw 'Username atau kata sandi salah.';
  }
}

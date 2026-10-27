import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/authentication_model.dart';
import 'authentication_remote_data_source.dart';

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final http.Client client;
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  const AuthenticationRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthenticationModel> loginWithUsernamePassword({
    required String username,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthenticationModel.fromJson(json);
    } else if (response.statusCode == 422 || response.statusCode == 401) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final message =
          json['message'] as String? ?? 'Username atau kata sandi salah.';
      throw message;
    } else {
      throw 'Terjadi kesalahan pada server. Coba lagi nanti.';
    }
  }
}

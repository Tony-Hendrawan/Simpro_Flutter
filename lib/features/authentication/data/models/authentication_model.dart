import '../../domain/entities/authentication.dart';

class AuthenticationModel extends Authentication {
  const AuthenticationModel({
    required super.id,
    required super.name,
    required super.username,
    required super.email,
    required super.role,
    required super.token,
  });

  factory AuthenticationModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? json;
    return AuthenticationModel(
      id: user['id'] as int? ?? 0,
      name: user['name'] as String? ?? '',
      username: user['username'] as String? ?? '',
      email: user['email'] as String? ?? '',
      role: user['role'] as String? ?? '',
      token: json['token'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'role': role,
      'token': token,
    };
  }

  factory AuthenticationModel.fromEntity(Authentication auth) {
    return AuthenticationModel(
      id: auth.id,
      name: auth.name,
      username: auth.username,
      email: auth.email,
      role: auth.role,
      token: auth.token,
    );
  }
}
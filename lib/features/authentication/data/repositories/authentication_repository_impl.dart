import 'package:fpdart/fpdart.dart';
import '../../domain/entities/authentication.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../data_sources/authentication_local_data_source.dart';
import '../models/authentication_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationLocalDataSource localDataSource;

  const AuthenticationRepositoryImpl({required this.localDataSource});

  static const String _userKey = 'cached_user';

  @override
  Future<Either<String, Authentication>> loginWithUsernamePassword({
    required String username,
    required String password,
  }) async {
    try {
      final authModel = await localDataSource.loginWithUsernamePassword(
        username: username,
        password: password,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(authModel.toJson()));
      return Right(authModel);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  @override
  Future<Authentication?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson == null) return null;
      final map = jsonDecode(userJson) as Map<String, dynamic>;
      return AuthenticationModel.fromJson({'user': map, 'token': map['token']});
    } catch (_) {
      return null;
    }
  }
}

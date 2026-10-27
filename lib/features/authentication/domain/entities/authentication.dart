class Authentication {
  final int id;
  final String name;
  final String username;
  final String email;
  final String role;
  final String token;

  const Authentication({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.role,
    required this.token,
  });
}
class UserAccountEntity {
  final int id;
  final String name;
  final String username;
  final String
  role; // 'owner', 'admin', 'logistik', 'keuangan', 'pelaksana', 'pengawas'
  final String email;
  final String status; // 'aktif', 'nonaktif'

  const UserAccountEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
    required this.email,
    required this.status,
  });
}

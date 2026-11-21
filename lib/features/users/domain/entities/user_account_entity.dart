class UserAccountEntity {
  final int id;
  final String name;
  final String username;
  final String role; // 'owner','admin','logistik','keuangan','pengawas','konsultan','administrasi','marketing'
  final String email;
  final String status; // 'aktif', 'nonaktif'
  final String joinDate;

  const UserAccountEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
    required this.email,
    required this.status,
    required this.joinDate,
  });
}

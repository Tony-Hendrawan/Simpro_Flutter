import '../../domain/entities/user_account_entity.dart';

class UserAccountModel extends UserAccountEntity {
  const UserAccountModel({
    required super.id,
    required super.name,
    required super.username,
    required super.role,
    required super.email,
    required super.status,
  });

  static List<UserAccountModel> get mockUsers => const [
    UserAccountModel(
      id: 1,
      name: 'Ir. H. Hendra Wijaya',
      username: 'owner',
      role: 'owner',
      email: 'owner@arthamasgraha.com',
      status: 'aktif',
    ),
    UserAccountModel(
      id: 2,
      name: 'Admin Sistem',
      username: 'admin',
      role: 'admin',
      email: 'admin@arthamasgraha.com',
      status: 'aktif',
    ),
    UserAccountModel(
      id: 3,
      name: 'Andi Wijaya, ST',
      username: 'pengawas',
      role: 'pengawas',
      email: 'pengawas.lapangan@arthamasgraha.com',
      status: 'aktif',
    ),
    UserAccountModel(
      id: 4,
      name: 'Agus Setiawan',
      username: 'logistik',
      role: 'logistik',
      email: 'gudang.logistik@arthamasgraha.com',
      status: 'aktif',
    ),
    UserAccountModel(
      id: 5,
      name: 'Ratna Sari, SE',
      username: 'keuangan',
      role: 'keuangan',
      email: 'finance@arthamasgraha.com',
      status: 'aktif',
    ),
  ];
}

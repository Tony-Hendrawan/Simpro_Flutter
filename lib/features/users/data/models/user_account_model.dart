import '../../domain/entities/user_account_entity.dart';

class UserAccountModel extends UserAccountEntity {
  const UserAccountModel({
    required super.id,
    required super.name,
    required super.username,
    required super.role,
    required super.email,
    required super.status,
    required super.joinDate,
  });

  static List<UserAccountModel> get mockUsers => [
        UserAccountModel(
          id: 1,
          name: 'Owner',
          username: 'owner',
          role: 'owner',
          email: 'owner@arthamasgraha.com',
          status: 'aktif',
          joinDate: '16/11/2026',
        ),
        UserAccountModel(
          id: 2,
          name: 'Admin Sistem',
          username: 'admin',
          role: 'admin',
          email: 'admin@arthamasgraha.com',
          status: 'aktif',
          joinDate: '16/11/2026',
        ),
        UserAccountModel(
          id: 3,
          name: 'Administrasi',
          username: 'administrasi',
          role: 'administrasi',
          email: 'administrasi@arthamasgraha.com',
          status: 'aktif',
          joinDate: '16/11/2026',
        ),
        UserAccountModel(
          id: 4,
          name: 'Konsultan Teknik',
          username: 'konsultan',
          role: 'konsultan',
          email: 'konsultan@arthamasgraha.com',
          status: 'aktif',
          joinDate: '16/11/2026',
        ),
        UserAccountModel(
          id: 5,
          name: 'Pengawas Lapangan',
          username: 'pengawas',
          role: 'pengawas',
          email: 'pengawas@arthamasgraha.com',
          status: 'aktif',
          joinDate: '16/11/2026',
        ),
        UserAccountModel(
          id: 6,
          name: 'Logistik',
          username: 'logistik',
          role: 'logistik',
          email: 'logistik@arthamasgraha.com',
          status: 'aktif',
          joinDate: '16/11/2026',
        ),
        UserAccountModel(
          id: 7,
          name: 'Marketing',
          username: 'marketing',
          role: 'marketing',
          email: 'marketing@arthamasgraha.com',
          status: 'aktif',
          joinDate: '16/11/2026',
        ),
        UserAccountModel(
          id: 8,
          name: 'Keuangan',
          username: 'keuangan',
          role: 'keuangan',
          email: 'keuangan@arthamasgraha.com',
          status: 'aktif',
          joinDate: '16/11/2026',
        ),
      ];
}

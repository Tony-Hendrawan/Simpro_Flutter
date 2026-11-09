import 'package:flutter/material.dart';
import '../../data/models/user_account_model.dart';
import '../../domain/entities/user_account_entity.dart';

class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({super.key});

  static const String routeName = '/users-management';

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  final List<UserAccountEntity> _users = List.from(UserAccountModel.mockUsers);
  String _selectedRole = 'Semua Peran';

  List<UserAccountEntity> get _filteredUsers {
    if (_selectedRole == 'Semua Peran') return _users;
    return _users.where((u) => u.role.toLowerCase() == _selectedRole.toLowerCase()).toList();
  }

  String _getRoleLabel(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return 'Owner / Direktur';
      case 'admin':
        return 'Administrator Sistem';
      case 'administrasi':
        return 'Staf Administrasi';
      case 'konsultan':
        return 'Konsultan Teknik';
      case 'pengawas':
        return 'Pengawas Lapangan';
      case 'logistik':
        return 'Staf Logistik';
      case 'keuangan':
        return 'Staf Keuangan';
      default:
        return role;
    }
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return const Color(0xFF1D4ED8);
      case 'admin':
        return const Color(0xFF6D28D9);
      case 'keuangan':
        return const Color(0xFF059669);
      case 'pengawas':
        return const Color(0xFF0284C7);
      case 'logistik':
        return const Color(0xFFD97706);
      default:
        return const Color(0xFF475569);
    }
  }

  void _showAddUserModal() {
    final nameController = TextEditingController();
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    String role = 'pengawas';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tambah Akun Pengguna', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Nama Lengkap', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              const SizedBox(height: 6),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Nama lengkap beserta gelar',
                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Username Akun', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              const SizedBox(height: 6),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'username unik tanpa spasi',
                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Email Pengguna', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              const SizedBox(height: 6),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'nama@arthamasgraha.com',
                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Peran Hak Akses (RBAC)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: role,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                items: const [
                  DropdownMenuItem(value: 'owner', child: Text('Owner / Direktur', style: TextStyle(fontSize: 13))),
                  DropdownMenuItem(value: 'admin', child: Text('Administrator Sistem', style: TextStyle(fontSize: 13))),
                  DropdownMenuItem(value: 'administrasi', child: Text('Staf Administrasi', style: TextStyle(fontSize: 13))),
                  DropdownMenuItem(value: 'konsultan', child: Text('Konsultan Teknik', style: TextStyle(fontSize: 13))),
                  DropdownMenuItem(value: 'pengawas', child: Text('Pengawas Lapangan', style: TextStyle(fontSize: 13))),
                  DropdownMenuItem(value: 'logistik', child: Text('Staf Logistik', style: TextStyle(fontSize: 13))),
                  DropdownMenuItem(value: 'keuangan', child: Text('Staf Keuangan', style: TextStyle(fontSize: 13))),
                ],
                onChanged: (val) {
                  if (val != null) role = val;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty || usernameController.text.trim().isEmpty) return;
                    setState(() {
                      _users.insert(
                        0,
                        UserAccountEntity(
                          id: DateTime.now().millisecondsSinceEpoch,
                          name: nameController.text.trim(),
                          username: usernameController.text.trim(),
                          role: role,
                          email: emailController.text.trim().isNotEmpty
                              ? emailController.text.trim()
                              : '${usernameController.text.trim()}@arthamasgraha.com',
                          status: 'aktif',
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Akun pengguna baru berhasil dibuat!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('SIMPAN AKUN PENGGUNA', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredUsers;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kelola Pengguna',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_rounded, color: Color(0xFF1D4ED8)),
            tooltip: 'Tambah Akun',
            onPressed: _showAddUserModal,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Peran Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Semua Peran', 'Owner', 'Admin', 'Pengawas', 'Logistik', 'Keuangan'].map((r) {
                    final isSel = _selectedRole.toLowerCase() == r.toLowerCase();
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(r),
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSel ? Colors.white : const Color(0xFF475569),
                        ),
                        selected: isSel,
                        selectedColor: const Color(0xFF1D4ED8),
                        backgroundColor: const Color(0xFFF1F5F9),
                        onSelected: (_) => setState(() => _selectedRole = r),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // Users List
            Expanded(
              child: list.isEmpty
                  ? const Center(child: Text('Tidak ada akun pada filter ini.', style: TextStyle(color: Color(0xFF94A3B8))))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: list.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final u = list[index];
                        final roleColor = _getRoleColor(u.role);

                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: roleColor.withValues(alpha: 0.1),
                                child: Text(
                                  u.name.isNotEmpty ? u.name[0].toUpperCase() : 'U',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: roleColor),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      u.name,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '@${u.username} · ${u.email}',
                                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: roleColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        _getRoleLabel(u.role),
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: roleColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

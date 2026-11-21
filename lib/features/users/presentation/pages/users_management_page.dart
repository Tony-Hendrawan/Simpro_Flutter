import 'package:flutter/material.dart';
import '../../../../core/widgets/summary_widgets.dart';
import '../../data/models/user_account_model.dart';
import '../../domain/entities/user_account_entity.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DATA: Struktur hak akses per modul
// ─────────────────────────────────────────────────────────────────────────────
class _Permission {
  final String key;
  final String label;
  final IconData icon;
  _Permission(this.key, this.label, this.icon);
}

class _Module {
  final String name;
  final List<_Permission> permissions;
  _Module(this.name, this.permissions);
}

final List<_Module> _allModules = [
  _Module('Dashboard', [
    _Permission('dashboard.view', 'Melihat Data (View)', Icons.visibility_outlined),
  ]),
  _Module('Projects', [
    _Permission('projects.view', 'Melihat Data (View)', Icons.visibility_outlined),
    _Permission('projects.create', 'Menambah Data (Create)', Icons.add),
    _Permission('projects.edit', 'Mengubah Data (Edit)', Icons.edit_outlined),
    _Permission('projects.delete', 'Menghapus Data (Delete)', Icons.delete_outlined),
  ]),
  _Module('Clients', [
    _Permission('clients.view', 'Melihat Data (View)', Icons.visibility_outlined),
    _Permission('clients.create', 'Menambah Data (Create)', Icons.add),
    _Permission('clients.edit', 'Mengubah Data (Edit)', Icons.edit_outlined),
    _Permission('clients.delete', 'Menghapus Data (Delete)', Icons.delete_outlined),
  ]),
  _Module('Progress', [
    _Permission('progress.view', 'Melihat Data (View)', Icons.visibility_outlined),
    _Permission('progress.create', 'Menambah Data (Create)', Icons.add),
  ]),
  _Module('Materials', [
    _Permission('materials.view', 'Melihat Data (View)', Icons.visibility_outlined),
    _Permission('materials.create', 'Menambah Data (Create)', Icons.add),
    _Permission('materials.edit', 'Mengubah Data (Edit)', Icons.edit_outlined),
    _Permission('materials.delete', 'Menghapus Data (Delete)', Icons.delete_outlined),
  ]),
  _Module('Material Requests', [
    _Permission('material_requests.view', 'Melihat Data (View)', Icons.visibility_outlined),
    _Permission('material_requests.create', 'Menambah Data (Create)', Icons.add),
    _Permission('material_requests.edit', 'Mengubah Data (Edit)', Icons.edit_outlined),
    _Permission('material_requests.delete', 'Menghapus Data (Delete)', Icons.delete_outlined),
    _Permission('material_requests.approve', 'Menyetujui (Approve)', Icons.check_circle_outline),
  ]),
  _Module('Equipments', [
    _Permission('equipments.view', 'Melihat Data (View)', Icons.visibility_outlined),
    _Permission('equipments.create', 'Menambah Data (Create)', Icons.add),
    _Permission('equipments.edit', 'Mengubah Data (Edit)', Icons.edit_outlined),
    _Permission('equipments.delete', 'Menghapus Data (Delete)', Icons.delete_outlined),
  ]),
  _Module('Finance', [
    _Permission('finance.view', 'Melihat Data (View)', Icons.visibility_outlined),
    _Permission('finance.create', 'Menambah Data (Create)', Icons.add),
  ]),
  _Module('Documents', [
    _Permission('documents.view', 'Melihat Data (View)', Icons.visibility_outlined),
    _Permission('documents.create', 'Menambah Data (Create)', Icons.add),
    _Permission('documents.delete', 'Menghapus Data (Delete)', Icons.delete_outlined),
  ]),
  _Module('Reports', [
    _Permission('reports.view', 'Melihat Data (View)', Icons.visibility_outlined),
    _Permission('reports.export', 'Ekspor Data (Export)', Icons.delete_outlined),
  ]),
  _Module('Users', [
    _Permission('users.view', 'Melihat Data (View)', Icons.visibility_outlined),
    _Permission('users.create', 'Menambah Data (Create)', Icons.add),
    _Permission('users.edit', 'Mengubah Data (Edit)', Icons.edit_outlined),
    _Permission('users.delete', 'Menghapus Data (Delete)', Icons.delete_outlined),
  ]),
  _Module('Site Surveys', [
    _Permission('site-surveys.view', 'Melihat Data (View)', Icons.visibility_outlined),
    _Permission('site-surveys.create', 'Menambah Data (Create)', Icons.add),
    _Permission('site-surveys.edit', 'Mengubah Data (Edit)', Icons.edit_outlined),
    _Permission('site-surveys.approve', 'Menyetujui (Approve)', Icons.check_circle_outline),
  ]),
  _Module('Settings', [
    _Permission('settings.view', 'Melihat Data (View)', Icons.visibility_outlined),
    _Permission('settings.edit', 'Mengubah Data (Edit)', Icons.edit_outlined),
  ]),
];

// ─────────────────────────────────────────────────────────────────────────────
// PAGE: Hak Akses (RBAC) per pengguna
// ─────────────────────────────────────────────────────────────────────────────
class _AccessRightsPage extends StatefulWidget {
  final UserAccountEntity user;
  const _AccessRightsPage({required this.user});

  @override
  State<_AccessRightsPage> createState() => _AccessRightsPageState();
}

class _AccessRightsPageState extends State<_AccessRightsPage> {
  late final Set<String> _enabled;

  @override
  void initState() {
    super.initState();
    // Default: view semua modul aktif
    _enabled = {
      'dashboard.view',
      'projects.view',
      'progress.view',
      'documents.view',
      'reports.view',
      'site-surveys.view',
    };
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.user;
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
          'Hak Akses (RBAC)',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
      ),
      body: Column(
        children: [
          // User identity strip
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFEFF6FF),
                  child: Text(
                    _initials(u.name),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8), fontSize: 14),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(u.name,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      Text('@${u.username}',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Text(
                    _roleLabel(u.role),
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: const Color(0xFFE2E8F0)),
          // Modules list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _allModules.length + 1, // +1 for save button
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                if (i == _allModules.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              side: const BorderSide(color: Color(0xFFE2E8F0)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Batal',
                                style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(children: [
                                    const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text('Hak akses ${u.name} berhasil disimpan.')),
                                  ]),
                                  backgroundColor: const Color(0xFF059669),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            },
                            icon: const Icon(Icons.shield_outlined, size: 18),
                            label: const Text('Simpan Hak Akses',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1D4ED8),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final mod = _allModules[i];
                final enabledCount = mod.permissions.where((p) => _enabled.contains(p.key)).length;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      // Module header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        child: Row(
                          children: [
                            Text(
                              'Modul ${mod.name}',
                              style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$enabledCount',
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF64748B)),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  final allKeys = mod.permissions.map((p) => p.key).toSet();
                                  if (allKeys.every(_enabled.contains)) {
                                    _enabled.removeAll(allKeys);
                                  } else {
                                    _enabled.addAll(allKeys);
                                  }
                                });
                              },
                              child: Text(
                                'Pilih Semua',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: mod.permissions.map((p) => p.key).every(_enabled.contains)
                                      ? const Color(0xFF1D4ED8)
                                      : const Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      // Permissions
                      ...mod.permissions.map((p) {
                        final checked = _enabled.contains(p.key);
                        return InkWell(
                          onTap: () => setState(() {
                            if (checked) {
                              _enabled.remove(p.key);
                            } else {
                              _enabled.add(p.key);
                            }
                          }),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: checked,
                                    onChanged: (v) => setState(() {
                                      if (v == true) {
                                        _enabled.add(p.key);
                                      } else {
                                        _enabled.remove(p.key);
                                      }
                                    }),
                                    activeColor: const Color(0xFF1D4ED8),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(p.icon, size: 15, color: const Color(0xFF64748B)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    p.label,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: checked
                                          ? const Color(0xFF0F172A)
                                          : const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ),
                                Text(
                                  p.key,
                                  style: const TextStyle(
                                      fontSize: 9.5,
                                      color: Color(0xFFCBD5E1),
                                      fontFamily: 'monospace'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PAGE: Manajemen Akun Pengguna (utama)
// ─────────────────────────────────────────────────────────────────────────────
class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({super.key});

  static const String routeName = '/users-management';

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  final List<UserAccountEntity> _users = List.from(UserAccountModel.mockUsers);
  final _searchCtrl = TextEditingController();
  String _roleFilter = 'Semua';
  bool _isListExpanded = false;

  static const _roleOptions = [
    ('Semua', 'Semua Jabatan (Peran)'),
    ('owner', 'Owner / Direktur'),
    ('admin', 'Administrator Sistem'),
    ('keuangan', 'Staf Keuangan'),
    ('logistik', 'Staf Logistik'),
    ('pengawas', 'Pengawas Lapangan'),
    ('konsultan', 'Konsultan Teknik'),
    ('administrasi', 'Staf Administrasi'),
    ('marketing', 'Staf Pemasaran'),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<UserAccountEntity> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    return _users.where((u) {
      final matchRole = _roleFilter == 'Semua' || u.role == _roleFilter;
      final matchSearch = q.isEmpty ||
          u.name.toLowerCase().contains(q) ||
          u.username.toLowerCase().contains(q);
      return matchRole && matchSearch;
    }).toList();
  }

  // ── helpers ──────────────────────────────────────────────────────────────
  String _initials(String name) {
    final p = name.trim().split(' ');
    if (p.length >= 2) return '${p[0][0]}${p[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  // ── modals ────────────────────────────────────────────────────────────────
  void _showAddModal() {
    final nameCtrl = TextEditingController();
    final userCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    String role = 'owner';
    bool obscure = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.person_add_rounded,
                        color: Color(0xFF1D4ED8), size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tambah Akun Pengguna',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A))),
                        Text('Daftarkan akun staf baru ke dalam sistem SIMPRO.',
                            style:
                                TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(ctx)),
                ]),
                const SizedBox(height: 16),

                _modalLabel('Nama Lengkap *'),
                const SizedBox(height: 6),
                _modalField(nameCtrl, 'Contoh: Ir. Budi Santoso'),
                const SizedBox(height: 12),

                _modalLabel('Username *'),
                const SizedBox(height: 6),
                _modalField(userCtrl, 'budi_santoso (tanpa spasi)'),
                const SizedBox(height: 12),

                Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _modalLabel('Kata Sandi *'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: passCtrl,
                          obscureText: obscure,
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: 'Minimal 8 karakter...',
                            hintStyle: const TextStyle(
                                fontSize: 11, color: Color(0xFF94A3B8)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE2E8F0))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE2E8F0))),
                            suffixIcon: IconButton(
                              icon: Icon(
                                  obscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 18,
                                  color: const Color(0xFF94A3B8)),
                              onPressed: () => setModal(() => obscure = !obscure),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _modalLabel('Jabatan / Peran *'),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: role,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE2E8F0))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE2E8F0))),
                          ),
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF0F172A)),
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                                value: 'owner',
                                child: Text('Owner / Direktur')),
                            DropdownMenuItem(
                                value: 'admin',
                                child: Text('Administrator Sistem')),
                            DropdownMenuItem(
                                value: 'keuangan', child: Text('Staf Keuangan')),
                            DropdownMenuItem(
                                value: 'logistik', child: Text('Staf Logistik')),
                            DropdownMenuItem(
                                value: 'pengawas',
                                child: Text('Pengawas Lapangan')),
                            DropdownMenuItem(
                                value: 'konsultan',
                                child: Text('Konsultan Teknik')),
                            DropdownMenuItem(
                                value: 'administrasi',
                                child: Text('Staf Administrasi')),
                            DropdownMenuItem(
                                value: 'marketing',
                                child: Text('Staf Pemasaran')),
                          ],
                          onChanged: (val) {
                            if (val != null) setModal(() => role = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
                const SizedBox(height: 14),

                // Info chip
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.info_outline_rounded,
                          size: 15, color: Color(0xFF1D4ED8)),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Pengguna baru akan otomatis mendapatkan izin akses standar sesuai peran yang dipilih. Anda dapat menyesuaikan hak akses per modul kapan saja melalui menu Hak Akses.',
                          style:
                              TextStyle(fontSize: 10.5, color: Color(0xFF334155)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Batal',
                          style: TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final name = nameCtrl.text.trim();
                        final uname = userCtrl.text.trim();
                        if (name.isEmpty || uname.isEmpty) return;
                        final now = DateTime.now();
                        final date =
                            '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
                        setState(() {
                          _users.insert(
                            0,
                            UserAccountModel(
                              id: now.millisecondsSinceEpoch,
                              name: name,
                              username: uname,
                              role: role,
                              email: '$uname@arthamasgraha.com',
                              status: 'aktif',
                              joinDate: date,
                            ),
                          );
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(children: [
                            const Icon(Icons.check_circle_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text('Akun $name berhasil didaftarkan.')),
                          ]),
                          backgroundColor: const Color(0xFF059669),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ));
                      },
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text('Daftarkan Akun',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D4ED8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditModal(UserAccountEntity u) {
    final nameCtrl = TextEditingController(text: u.name);
    final userCtrl = TextEditingController(text: u.username);
    String role = u.role;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.manage_accounts_rounded,
                        color: Color(0xFF1D4ED8), size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Edit Profil Pengguna',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A))),
                        Text('Perbarui identitas dan jabatan akun ${u.name}.',
                            style: const TextStyle(
                                fontSize: 10.5, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(ctx)),
                ]),
                const SizedBox(height: 16),

                _modalLabel('Nama Lengkap *'),
                const SizedBox(height: 6),
                _modalField(nameCtrl, 'Nama lengkap'),
                const SizedBox(height: 12),

                _modalLabel('Username *'),
                const SizedBox(height: 6),
                _modalField(userCtrl, 'username'),
                const SizedBox(height: 12),

                _modalLabel('Jabatan / Peran Sistem *'),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: role,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  ),
                  style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'owner', child: Text('Owner / Direktur')),
                    DropdownMenuItem(value: 'admin', child: Text('Administrator Sistem')),
                    DropdownMenuItem(value: 'keuangan', child: Text('Staf Keuangan')),
                    DropdownMenuItem(value: 'logistik', child: Text('Staf Logistik')),
                    DropdownMenuItem(value: 'pengawas', child: Text('Pengawas Lapangan')),
                    DropdownMenuItem(value: 'konsultan', child: Text('Konsultan Teknik')),
                    DropdownMenuItem(value: 'administrasi', child: Text('Staf Administrasi')),
                    DropdownMenuItem(value: 'marketing', child: Text('Staf Pemasaran')),
                  ],
                  onChanged: (val) {
                    if (val != null) setModal(() => role = val);
                  },
                ),
                const SizedBox(height: 10),

                // Link ke hak akses
                GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => _AccessRightsPage(user: u)),
                    );
                  },
                  child: const Text(
                    'Kelola Hak Akses →',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1D4ED8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Batal',
                          style: TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final name = nameCtrl.text.trim();
                        if (name.isEmpty) return;
                        setState(() {
                          final idx = _users.indexWhere((x) => x.id == u.id);
                          if (idx != -1) {
                            _users[idx] = UserAccountModel(
                              id: u.id,
                              name: name,
                              username: userCtrl.text.trim(),
                              role: role,
                              email: u.email,
                              status: u.status,
                              joinDate: u.joinDate,
                            );
                          }
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(children: [
                            const Icon(Icons.check_circle_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text('Profil $name berhasil diperbarui.')),
                          ]),
                          backgroundColor: const Color(0xFF059669),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ));
                      },
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text('Simpan Perubahan',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D4ED8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(UserAccountEntity u) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Akun Pengguna?',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        content: Text(
          'Akun "${u.name}" akan dihapus permanen dari sistem. Tindakan ini tidak dapat dibatalkan.',
          style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal',
                style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _users.removeWhere((x) => x.id == u.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Akun ${u.name} dihapus.'),
                backgroundColor: const Color(0xFFE11D48),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE11D48),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text('Hapus',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ── build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    final total = _users.length;
    final mgmt = _users.where((u) => u.role == 'owner' || u.role == 'admin').length;
    final teknik = _users.where((u) =>
            u.role == 'pengawas' ||
            u.role == 'konsultan' ||
            u.role == 'logistik').length;
    final bisnis = _users
        .where((u) =>
            u.role == 'keuangan' ||
            u.role == 'administrasi' ||
            u.role == 'marketing')
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Manajemen Pengguna',
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton.icon(
              onPressed: _showAddModal,
              icon: const Icon(Icons.person_add_rounded, size: 16),
              label: const Text('Tambah',
                  style:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D4ED8),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Kotakan Total dll (Format Standar Simpro Seperti di Fitur Lain) ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Total Pengguna',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          '$total',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(height: 1, color: Color(0xFFE2E8F0)),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppStatusMetricBox(
                            label: 'Manajemen & TI',
                            value: mgmt,
                            indicatorColor: const Color(0xFF1D4ED8),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: AppStatusMetricBox(
                            label: 'Teknik & Lapangan',
                            value: teknik,
                            indicatorColor: const Color(0xFFD97706),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: AppStatusMetricBox(
                            label: 'Admin & Bisnis',
                            value: bisnis,
                            indicatorColor: const Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── 2. Search & Dropdown (Penataan Sama Kayak di Fitur Lain: Dalam Card Putih) ──
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchCtrl,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'Cari berdasarkan nama lengkap atau username...',
                        hintStyle: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          size: 18,
                          color: Color(0xFF94A3B8),
                        ),
                        suffixIcon: _searchCtrl.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 16),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF1D4ED8), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _roleFilter,
                      isExpanded: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF1D4ED8), width: 1.5),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.w600,
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: Color(0xFF64748B),
                      ),
                      items: _roleOptions.map((r) {
                        return DropdownMenuItem(
                          value: r.$1,
                          child: Text(
                            r.$1 == 'Semua' ? '-- Semua Jabatan (Peran) --' : r.$2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _roleFilter = v);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── 3. Daftar Akun Tim (Sembunyi Dulu Sebelum Diklik / Collapsible) ──
              InkWell(
                onTap: () => setState(() => _isListExpanded = !_isListExpanded),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.people_alt_outlined,
                          size: 18,
                          color: Color(0xFF1D4ED8),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Daftar Akun Tim',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              _isListExpanded
                                  ? 'Ketuk untuk menyembunyikan daftar akun'
                                  : '${list.length} Akun terdaftar • Ketuk untuk membuka',
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${list.length} Akun',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D4ED8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        _isListExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: const Color(0xFF64748B),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),

              // ── 4. Konten Daftar Akun Tim (Muncul Saat Dibuka) ──
              if (_isListExpanded) ...[
                const SizedBox(height: 10),
                if (list.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: const [
                        Icon(Icons.person_off_outlined, size: 40, color: Color(0xFFCBD5E1)),
                        SizedBox(height: 10),
                        Text(
                          'Tidak ada akun pengguna ditemukan',
                          style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final u = list[i];
                      final rc = _roleColor(u.role);
                      final rb = _roleBg(u.role);
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Avatar
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: rb,
                              child: Text(
                                _initials(u.name),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: rc,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    u.name,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '@${u.username} • ${u.email}',
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      color: Color(0xFF64748B),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: rb,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          _roleLabel(u.role),
                                          style: TextStyle(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.bold,
                                            color: rc,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: u.status == 'aktif'
                                              ? const Color(0xFF10B981)
                                              : const Color(0xFF94A3B8),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        u.status == 'aktif' ? 'Aktif' : 'Non-Aktif',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: u.status == 'aktif'
                                              ? const Color(0xFF10B981)
                                              : const Color(0xFF94A3B8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),

                            // ── Penataan Edit, Permission, Delete: Vertikal, Agak Gede, dan Berjarak ──
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _actionButton(
                                  icon: Icons.edit_outlined,
                                  color: const Color(0xFF1D4ED8),
                                  bg: const Color(0xFFEFF6FF),
                                  tooltip: 'Edit Profil',
                                  onTap: () => _showEditModal(u),
                                ),
                                const SizedBox(height: 8),
                                _actionButton(
                                  icon: Icons.shield_outlined,
                                  color: const Color(0xFF059669),
                                  bg: const Color(0xFFECFDF5),
                                  tooltip: 'Hak Akses RBAC',
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => _AccessRightsPage(user: u),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _actionButton(
                                  icon: Icons.delete_outline_rounded,
                                  color: const Color(0xFFE11D48),
                                  bg: const Color(0xFFFFF1F2),
                                  tooltip: 'Hapus Akun',
                                  onTap: () => _confirmDelete(u),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── widget helpers ────────────────────────────────────────────────────────
  Widget _actionButton({
    required IconData icon,
    required Color color,
    required Color bg,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: Icon(icon, size: 17, color: color),
        ),
      ),
    );
  }

  Widget _modalLabel(String text) => Text(text,
      style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF475569)));

  Widget _modalField(TextEditingController ctrl, String hint) => TextField(
        controller: ctrl,
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Color(0xFF1D4ED8), width: 1.5)),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// GLOBAL HELPERS (also used by _AccessRightsPage)
// ─────────────────────────────────────────────────────────────────────────────
String _roleLabel(String role) {
  switch (role) {
    case 'owner': return 'Owner / Direktur';
    case 'admin': return 'Administrator Sistem';
    case 'keuangan': return 'Staf Keuangan';
    case 'logistik': return 'Staf Logistik';
    case 'pengawas': return 'Pengawas Lapangan';
    case 'konsultan': return 'Konsultan Teknik';
    case 'administrasi': return 'Staf Administrasi';
    case 'marketing': return 'Staf Pemasaran';
    default: return role;
  }
}

Color _roleColor(String role) {
  switch (role) {
    case 'owner': return const Color(0xFF1D4ED8);
    case 'admin': return const Color(0xFF4F46E5);
    case 'keuangan': return const Color(0xFF059669);
    case 'pengawas': return const Color(0xFF0284C7);
    case 'konsultan': return const Color(0xFF7C3AED);
    case 'logistik': return const Color(0xFFD97706);
    case 'administrasi': return const Color(0xFF0EA5E9);
    case 'marketing': return const Color(0xFFDB2777);
    default: return const Color(0xFF475569);
  }
}

Color _roleBg(String role) {
  switch (role) {
    case 'owner': return const Color(0xFFEFF6FF);
    case 'admin': return const Color(0xFFEEF2FF);
    case 'keuangan': return const Color(0xFFECFDF5);
    case 'pengawas': return const Color(0xFFE0F2FE);
    case 'konsultan': return const Color(0xFFF5F3FF);
    case 'logistik': return const Color(0xFFFFFBEB);
    case 'administrasi': return const Color(0xFFF0F9FF);
    case 'marketing': return const Color(0xFFFDF2F8);
    default: return const Color(0xFFF1F5F9);
  }
}

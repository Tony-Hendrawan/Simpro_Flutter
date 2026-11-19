import 'package:flutter/material.dart';

import '../../../../core/access_control.dart';
import '../../../../core/widgets/summary_widgets.dart';
import '../../../authentication/domain/entities/authentication.dart';
import '../../../projects/data/models/project_model.dart';
import '../../data/models/equipment_model.dart';
import '../../domain/entities/equipment_entity.dart';

class EquipmentsPage extends StatefulWidget {
  const EquipmentsPage({super.key});

  static const String routeName = '/equipments';

  @override
  State<EquipmentsPage> createState() => _EquipmentsPageState();
}

class _EquipmentsPageState extends State<EquipmentsPage> {
  final List<EquipmentEntity> _equipments = List.from(EquipmentModel.mockEquipments);
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';
  Authentication? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await AccessControl.currentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  bool get _canManage {
    if (_currentUser == null) return true;
    final role = _currentUser!.role?.toLowerCase();
    // Di Simpro: owner, admin, logistik, pengawas berhak mengelola alat
    return role == 'owner' || role == 'admin' || role == 'logistik' || role == 'pengawas';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatRp(double val) {
    return 'Rp ${val.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  String _formatShortRp(double val) {
    if (val >= 1000000) {
      final inM = val / 1000000;
      return '${inM.toStringAsFixed(val % 1000000 == 0 ? 0 : 1)}jt/hr';
    } else if (val >= 1000) {
      return '${(val / 1000).toStringAsFixed(0)}rb/hr';
    }
    return '${val.toInt()}/hr';
  }

  List<EquipmentEntity> get _filteredEquipments {
    final q = _searchController.text.trim().toLowerCase();
    return _equipments.where((e) {
      final matchesStatus = _selectedFilter == 'all' || e.status.toLowerCase() == _selectedFilter.toLowerCase();
      final matchesSearch = q.isEmpty ||
          e.name.toLowerCase().contains(q) ||
          e.code.toLowerCase().contains(q) ||
          e.condition.toLowerCase().contains(q) ||
          (e.projectName ?? '').toLowerCase().contains(q) ||
          (e.projectLocation ?? '').toLowerCase().contains(q);
      return matchesStatus && matchesSearch;
    }).toList();
  }

  // Modal Pendaftaran Alat / Aset Baru (Persis Web v3)
  void _showAddEquipmentModal() {
    final nameCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    final conditionCtrl = TextEditingController(text: 'Baik');
    final costCtrl = TextEditingController(text: '0');
    String status = 'tersedia';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
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
                // Header Modal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Pendaftaran Alat / Aset Baru',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Lengkapi rincian inventaris alat berat atau peralatan kerja.',
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Nama Alat / Aset
                const Text('Nama Alat / Aset *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                const SizedBox(height: 6),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    hintText: 'Contoh: Excavator Komatsu PC200, Molen Cor 500L',
                    hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),

                // Kode Inventaris & Status Awal (2 Kolom)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Kode Inventaris *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                          const SizedBox(height: 6),
                          TextField(
                            controller: codeCtrl,
                            decoration: InputDecoration(
                              hintText: 'Contoh: EXC-001, MLN-002',
                              hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                          const Text('Status Awal *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            initialValue: status,
                            isExpanded: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'tersedia', child: Text('Tersedia di Gudang', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: 'diservis', child: Text('Dalam Perbaikan (Servis)', style: TextStyle(fontSize: 12))),
                            ],
                            onChanged: (val) {
                              if (val != null) setModalState(() => status = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Kondisi Fisik & Biaya Sewa / Hari (2 Kolom)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Kondisi Fisik *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                          const SizedBox(height: 6),
                          TextField(
                            controller: conditionCtrl,
                            decoration: InputDecoration(
                              hintText: 'Baik, Siap Pakai',
                              hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                          const Text('Biaya Sewa / Hari (Rp) *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                          const SizedBox(height: 6),
                          TextField(
                            controller: costCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '0 jika milik sendiri',
                              hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Tombol Aksi
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check_rounded, size: 16),
                      label: const Text('Simpan Data', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D4ED8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        if (nameCtrl.text.trim().isEmpty || codeCtrl.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Nama dan Kode Inventaris wajib diisi!'),
                              backgroundColor: Color(0xFFE11D48),
                            ),
                          );
                          return;
                        }

                        final cost = double.tryParse(costCtrl.text.trim()) ?? 0;
                        setState(() {
                          _equipments.insert(
                            0,
                            EquipmentEntity(
                              id: DateTime.now().millisecondsSinceEpoch,
                              code: codeCtrl.text.trim(),
                              name: nameCtrl.text.trim(),
                              status: status,
                              condition: conditionCtrl.text.trim().isEmpty ? 'Baik' : conditionCtrl.text.trim(),
                              dailyCost: cost,
                              currentProjectId: null,
                              projectName: null,
                              projectLocation: null,
                            ),
                          );
                        });

                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Alat / Aset baru berhasil didaftarkan!'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Color(0xFF059669),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Modal Pembaruan Status Aset (Persis Web v3)
  void _showEditEquipmentModal(EquipmentEntity item) {
    String currentStatus = item.status;
    int? selectedProjectId = item.currentProjectId;
    final conditionCtrl = TextEditingController(text: item.condition);
    final projects = ProjectModel.mockProjects;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
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
                // Header Modal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pembaruan Status Aset',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${item.name} (${item.code})',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Status Operasional
                const Text('Status Operasional *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: currentStatus,
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'tersedia', child: Text('Tersedia di Gudang', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'dipinjam', child: Text('Dipinjam ke Proyek', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'diservis', child: Text('Dalam Perbaikan (Servis)', style: TextStyle(fontSize: 12))),
                  ],
                  onChanged: (val) {
                    if (val != null) setModalState(() => currentStatus = val);
                  },
                ),
                const SizedBox(height: 12),

                // Proyek Penempatan jika status dipinjam
                if (currentStatus == 'dipinjam') ...[
                  const Text('Proyek Penempatan *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<int>(
                    initialValue: selectedProjectId,
                    isExpanded: true,
                    hint: const Text('— Pilih Proyek Tujuan —', style: TextStyle(fontSize: 12)),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    items: projects.map((p) {
                      return DropdownMenuItem<int>(
                        value: p.id,
                        child: Text(
                          '${p.name} (${p.location})',
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setModalState(() => selectedProjectId = val);
                    },
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Jika status diubah ke Tersedia atau Servis, lokasi alat otomatis dialihkan kembali ke Gudang.',
                    style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 12),
                ],

                // Kondisi Fisik Terkini
                const Text('Kondisi Fisik Terkini *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                const SizedBox(height: 6),
                TextField(
                  controller: conditionCtrl,
                  decoration: InputDecoration(
                    hintText: 'Contoh: Baik, Siap Pakai, Perlu Ganti Oli...',
                    hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),

                // Tombol Aksi
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save_rounded, size: 16),
                      label: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D4ED8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        if (currentStatus == 'dipinjam' && selectedProjectId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Proyek Penempatan wajib dipilih jika status Dipinjam!'),
                              backgroundColor: Color(0xFFE11D48),
                            ),
                          );
                          return;
                        }

                        final selectedProj = currentStatus == 'dipinjam'
                            ? projects.firstWhere((p) => p.id == selectedProjectId, orElse: () => projects.first)
                            : null;

                        setState(() {
                          final idx = _equipments.indexWhere((e) => e.id == item.id);
                          if (idx != -1) {
                            _equipments[idx] = item.copyWith(
                              status: currentStatus,
                              condition: conditionCtrl.text.trim().isEmpty ? item.condition : conditionCtrl.text.trim(),
                              clearProject: currentStatus != 'dipinjam',
                              currentProjectId: currentStatus == 'dipinjam' ? selectedProj?.id : null,
                              projectName: currentStatus == 'dipinjam' ? selectedProj?.name : null,
                              projectLocation: currentStatus == 'dipinjam' ? selectedProj?.location : null,
                            );
                          }
                        });

                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Status aset ${item.code} berhasil diperbarui!'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: const Color(0xFF059669),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredEquipments;
    final total = _equipments.length;
    final ready = _equipments.where((e) => e.status == 'tersedia').length;
    final inUse = _equipments.where((e) => e.status == 'dipinjam').length;
    final repair = _equipments.where((e) => e.status == 'diservis').length;
    final totalDailyCost = _equipments
        .where((e) => e.status == 'dipinjam')
        .fold(0.0, (sum, e) => sum + e.dailyCost);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0F172A),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Alat Berat & Peralatan',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
        actions: [
          if (_canManage) ...[
            IconButton(
              icon: const Icon(
                Icons.add_circle_rounded,
                color: Color(0xFF1E3A8A),
                size: 24,
              ),
              tooltip: 'Tambah Alat / Aset',
              onPressed: _showAddEquipmentModal,
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ringkasan Status Aset (Desain Sama Persis Fitur Survei & Pengajuan Material)
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
                            'Total Aset',
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
                            label: 'Tersedia',
                            value: ready,
                            indicatorColor: const Color(0xFF059669),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: AppStatusMetricBox(
                            label: 'Digunakan',
                            value: inUse,
                            indicatorColor: const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: AppStatusMetricBox(
                            label: 'Perbaikan',
                            value: repair,
                            indicatorColor: const Color(0xFFF59E0B),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: AppStatusMetricBox(
                            label: 'Sewa Aktif',
                            value: 0,
                            stringValue: totalDailyCost > 0 ? _formatShortRp(totalDailyCost) : 'Rp 0/hr',
                            indicatorColor: const Color(0xFF64748B),
                            valueFontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Filter & Pencarian (Sama Persis Fitur Sebelumnya)
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
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'Cari nama alat, kode, kondisi, atau lokasi...',
                        hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                        prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF94A3B8)),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 16),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Dropdown Status persis opsi web
                    DropdownButtonFormField<String>(
                      initialValue: _selectedFilter,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Color(0xFF64748B)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'all',
                          child: Text('Semua Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                        ),
                        DropdownMenuItem(
                          value: 'tersedia',
                          child: Text('Tersedia (Gudang)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                        ),
                        DropdownMenuItem(
                          value: 'dipinjam',
                          child: Text('Dipinjam (Proyek)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                        ),
                        DropdownMenuItem(
                          value: 'diservis',
                          child: Text('Dalam Perbaikan (Servis)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedFilter = val);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Daftar Inventaris Alat & Peralatan
              if (list.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.folder_open_rounded, size: 44, color: Color(0xFFCBD5E1)),
                      SizedBox(height: 12),
                      Text(
                        'Belum Ada Data Alat atau Peralatan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334155),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Silakan klik tombol "Tambah Alat / Aset" untuk mendaftarkan inventaris mesin atau alat kerja baru.',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: list.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final e = list[index];
                    final isReady = e.status.toLowerCase() == 'tersedia';
                    final isLoaned = e.status.toLowerCase() == 'dipinjam';

                    final badgeColor = isReady
                        ? const Color(0xFF059669)
                        : (isLoaned ? const Color(0xFF2563EB) : const Color(0xFFD97706));
                    final badgeBg = isReady
                        ? const Color(0xFFECFDF5)
                        : (isLoaned ? const Color(0xFFEFF6FF) : const Color(0xFFFFFBEB));
                    final badgeBorder = isReady
                        ? const Color(0xFFA7F3D0)
                        : (isLoaned ? const Color(0xFFBFDBFE) : const Color(0xFFFDE68A));
                    final statusLabel = isReady
                        ? 'Tersedia'
                        : (isLoaned ? 'Dipinjam' : 'Dalam Perbaikan');

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: Nama Alat & Badge Status
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      e.code,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'monospace',
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: badgeBg,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: badgeBorder),
                                ),
                                child: Text(
                                  statusLabel,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: badgeColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Lokasi Penempatan
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  e.projectName != null ? Icons.location_on_rounded : Icons.warehouse_rounded,
                                  size: 15,
                                  color: e.projectName != null ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.projectName != null ? e.projectName! : 'Gudang Pusat',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: e.projectName != null ? const Color(0xFF1E293B) : const Color(0xFF475569),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        e.projectName != null
                                            ? (e.projectLocation ?? 'Lokasi Proyek')
                                            : (isReady ? 'Siap dialokasikan' : 'Dalam pemeliharaan'),
                                        style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Kondisi & Biaya Sewa
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.build_circle_outlined, size: 13, color: Color(0xFF94A3B8)),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Kondisi: ${e.condition}',
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                              Text(
                                e.dailyCost > 0 ? '${_formatRp(e.dailyCost)} / hr' : 'Milik Sendiri (Rp 0)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: e.dailyCost > 0 ? const Color(0xFF2563EB) : const Color(0xFF059669),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Tombol Aksi Ubah Status
                          if (_canManage)
                            Align(
                              alignment: Alignment.centerRight,
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.edit_note_rounded, size: 15),
                                label: const Text('Ubah Status', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF334155),
                                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  visualDensity: VisualDensity.compact,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () => _showEditEquipmentModal(e),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/widgets/summary_widgets.dart';
import '../../../../core/access_control.dart';
import '../../../authentication/domain/entities/authentication.dart';
import '../../data/models/material_request_model.dart';
import '../../domain/entities/material_request_entity.dart';
import '../../../projects/data/models/project_model.dart';
import '../../../materials/data/models/material_model.dart';
import '../../../materials/presentation/pages/materials_page.dart';

class MaterialRequestsPage extends StatefulWidget {
  const MaterialRequestsPage({super.key});

  static const String routeName = '/material-requests';

  @override
  State<MaterialRequestsPage> createState() => _MaterialRequestsPageState();
}

class _MaterialRequestsPageState extends State<MaterialRequestsPage> {
  final List<MaterialRequestEntity> _requests = List.from(
    MaterialRequestModel.mockRequests,
  );
  final TextEditingController _searchController = TextEditingController();

  // Filter status: 'all', 'pending', 'approved', 'delivered', 'rejected'
  String _selectedFilter = 'all';

  Authentication? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() async {
    final user = await AccessControl.currentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  String _getRoleLabel(String? role) {
    switch (role?.toLowerCase()) {
      case 'owner':
        return 'Owner';
      case 'admin':
        return 'Administrator Sistem';
      case 'pengawas':
        return 'Pengawas Lapangan';
      case 'logistik':
        return 'Staf Logistik';
      case 'keuangan':
        return 'Staf Keuangan';
      case 'administrasi':
        return 'Staf Administrasi';
      case 'konsultan':
        return 'Konsultan Teknik';
      case 'pelaksana':
        return 'Pelaksana Lapangan';
      default:
        return role != null ? role.toUpperCase() : 'Staf Proyek';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MaterialRequestEntity> get _filteredRequests {
    final q = _searchController.text.trim().toLowerCase();
    return _requests.where((r) {
      final matchesFilter = _selectedFilter == 'all' ||
          r.status.toLowerCase() == _selectedFilter.toLowerCase();
      final matchesSearch = q.isEmpty ||
          r.requestCode.toLowerCase().contains(q) ||
          r.materialName.toLowerCase().contains(q) ||
          r.projectName.toLowerCase().contains(q) ||
          r.requestedBy.toLowerCase().contains(q);
      return matchesFilter && matchesSearch;
    }).toList();
  }

  String _formatRp(double val) {
    return 'Rp ${val.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  // --- Modal Formulir Pengajuan Material (Persis Versi Web) ---
  void _showAddRequestModal() {
    final availableProjects = ProjectModel.mockProjects;
    final availableMaterials = MaterialModel.mockMaterials;

    final requesterName = _currentUser?.name ?? 'Andi Wijaya, ST';
    final requesterRole = _getRoleLabel(_currentUser?.role ?? 'pengawas');

    String selectedProject = availableProjects.first.name;
    String materialSource = 'warehouse'; // 'warehouse' atau 'custom'

    MaterialModel? selectedWarehouseMaterial =
        availableMaterials.isNotEmpty ? availableMaterials.first : null;

    final customNameCtrl = TextEditingController();
    final customUnitCtrl = TextEditingController(text: 'Sak');
    final customPriceCtrl = TextEditingController(text: '0');

    final qtyCtrl = TextEditingController(text: '50');
    final notesCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final isWarehouse = materialSource == 'warehouse';

          final currentUnit = isWarehouse
              ? (selectedWarehouseMaterial?.unit ?? 'Unit')
              : (customUnitCtrl.text.isNotEmpty ? customUnitCtrl.text : 'Unit');

          final currentPrice = isWarehouse
              ? (selectedWarehouseMaterial?.pricePerUnit ?? 0.0)
              : (double.tryParse(customPriceCtrl.text.trim()) ?? 0.0);

          final qty = double.tryParse(qtyCtrl.text.trim()) ?? 0.0;
          final totalEstimasi = currentPrice * qty;

          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Formulir Pengajuan Material',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Lengkapi rincian material yang dibutuhkan proyek.',
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
                  const SizedBox(height: 14),

                  // Proyek Tujuan
                  const Text('Proyek Tujuan *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: selectedProject,
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    items: availableProjects
                        .map((p) => DropdownMenuItem(
                              value: p.name,
                              child: Text(
                                '[${p.status.toUpperCase()}] ${p.name}',
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedProject = val);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Sumber Pengadaan
                  const Text('Sumber Pengadaan *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: materialSource,
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'warehouse',
                        child: Text('Stok Gudang (Mengurangi persediaan gudang)', style: TextStyle(fontSize: 12)),
                      ),
                      DropdownMenuItem(
                        value: 'custom',
                        child: Text('Pengadaan Luar (Pembelian langsung ke supplier)', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setModalState(() => materialSource = val);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Pilihan Material jika Gudang vs Pengadaan Luar
                  if (isWarehouse) ...[
                    const Text('Pilih Material dari Gudang *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<int>(
                      initialValue: selectedWarehouseMaterial?.id,
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      items: availableMaterials
                          .map((m) => DropdownMenuItem<int>(
                                value: m.id,
                                child: Text(
                                  '${m.name} (Tersedia: ${m.stock} ${m.unit})',
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() {
                            selectedWarehouseMaterial = availableMaterials.firstWhere((m) => m.id == val);
                          });
                        }
                      },
                    ),
                    if (selectedWarehouseMaterial != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 14,
                            color: Color(0xFF2563EB),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Stok tersedia: ${selectedWarehouseMaterial!.stock} ${selectedWarehouseMaterial!.unit}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ] else ...[
                    const Text('Nama Material Baru / Luar *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: customNameCtrl,
                      decoration: InputDecoration(
                        hintText: 'Contoh: Paving Block K-300, Semen Putih',
                        hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),

                  // Satuan & Harga Satuan
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Satuan *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: isWarehouse
                                  ? TextEditingController(text: currentUnit)
                                  : customUnitCtrl,
                              readOnly: isWarehouse,
                              onChanged: (_) => setModalState(() {}),
                              decoration: InputDecoration(
                                filled: isWarehouse,
                                fillColor: isWarehouse ? const Color(0xFFF1F5F9) : Colors.white,
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
                            const Text('Harga Satuan (Rp) *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: isWarehouse
                                  ? TextEditingController(text: currentPrice.toInt().toString())
                                  : customPriceCtrl,
                              readOnly: isWarehouse,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setModalState(() {}),
                              decoration: InputDecoration(
                                filled: isWarehouse,
                                fillColor: isWarehouse ? const Color(0xFFF1F5F9) : Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Kuantitas
                  const Text('Kuantitas / Jumlah Kebutuhan *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: qtyCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setModalState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Masukkan jumlah yang dibutuhkan',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Real-time Total Estimasi Box persis web
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Estimasi Total Biaya',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                            ),
                            Text(
                              _formatRp(totalEstimasi),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1E3A8A)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Total dihitung otomatis (Harga Satuan × Kuantitas) untuk peninjauan manajemen.',
                          style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Catatan
                  const Text('Catatan Tambahan (Opsional)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: notesCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Tuliskan alasan permohonan atau instruksi khusus...',
                      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Tombol Aksi Batal & Kirim Pengajuan
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            final finalName = isWarehouse
                                ? (selectedWarehouseMaterial?.name ?? 'Material')
                                : customNameCtrl.text.trim();

                            if (finalName.isEmpty) return;

                            final finalQty = int.tryParse(qtyCtrl.text.trim()) ?? 1;
                            final finalCode = 'REQ-2026-00${_requests.length + 1}';

                            setState(() {
                              _requests.insert(
                                0,
                                MaterialRequestEntity(
                                  id: DateTime.now().millisecondsSinceEpoch,
                                  requestCode: finalCode,
                                  projectName: selectedProject,
                                  materialName: finalName,
                                  quantity: finalQty,
                                  unit: currentUnit,
                                  estimatedCost: totalEstimasi,
                                  status: 'pending',
                                  requestedBy: '$requesterName ($requesterRole)',
                                  notes: notesCtrl.text.trim().isNotEmpty ? notesCtrl.text.trim() : null,
                                  date: 'Hari ini',
                                ),
                              );
                            });

                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Pengajuan $finalCode berhasil dikirim.'),
                                backgroundColor: const Color(0xFF059669),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('KIRIM PENGAJUAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredRequests;
    final totalCount = _requests.length;
    final pendingCount = _requests.where((r) => r.status.toLowerCase() == 'pending').length;
    final approvedCount = _requests.where((r) => r.status.toLowerCase() == 'approved').length;
    final deliveredCount = _requests.where((r) => r.status.toLowerCase() == 'delivered').length;
    final rejectedCount = _requests.where((r) => r.status.toLowerCase() == 'rejected').length;

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
          'Pengajuan Material',
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
          // Tombol Stok Gudang sebagai ICON di sebelah kiri tombol plus dengan jarak
          IconButton(
            icon: const Icon(Icons.inventory_2_outlined, color: Color(0xFF64748B), size: 21),
            tooltip: 'Katalog Stok Gudang',
            onPressed: () => Navigator.pushNamed(context, MaterialsPage.routeName),
          ),
          const SizedBox(width: 8), // Berjarak
          // Tombol Plus Buat Pengajuan
          IconButton(
            icon: const Icon(Icons.add_circle_rounded, color: Color(0xFF1E3A8A), size: 24),
            tooltip: 'Buat Pengajuan',
            onPressed: _showAddRequestModal,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ringkasan Status (Sama persis desain Survei Lokasi / Validasi Survei)
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
                            'Total Pengajuan',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          '$totalCount',
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
                            label: 'Menunggu',
                            value: pendingCount,
                            indicatorColor: const Color(0xFFF59E0B),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: AppStatusMetricBox(
                            label: 'Disetujui',
                            value: approvedCount,
                            indicatorColor: const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: AppStatusMetricBox(
                            label: 'Distribusi',
                            value: deliveredCount,
                            indicatorColor: const Color(0xFF059669),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: AppStatusMetricBox(
                            label: 'Ditolak',
                            value: rejectedCount,
                            indicatorColor: const Color(0xFFE11D48),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Filter & Pencarian
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
                        hintText: 'Cari material, nama proyek, atau pengaju...',
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

                    // Dropdown Status persis opsi web yang diberikan user
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
                          value: 'pending',
                          child: Text('Menunggu Persetujuan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                        ),
                        DropdownMenuItem(
                          value: 'approved',
                          child: Text('Disetujui', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                        ),
                        DropdownMenuItem(
                          value: 'delivered',
                          child: Text('Didistribusikan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                        ),
                        DropdownMenuItem(
                          value: 'rejected',
                          child: Text('Ditolak', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
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

              // Request Cards List
              if (list.isEmpty)
                const AppEmptyStateCard(
                  icon: Icons.assignment_late_outlined,
                  title: 'Tidak Ada Pengajuan Material',
                  message: 'Tidak ditemukan permohonan material yang cocok dengan filter pencarian.',
                )
              else
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: list.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final r = list[index];
                    final st = r.status.toLowerCase();
                    final isDelivered = st == 'delivered';
                    final isApproved = st == 'approved';
                    final isPending = st == 'pending';

                    final badgeColor = isDelivered
                        ? const Color(0xFF059669)
                        : (isApproved
                            ? const Color(0xFF1D4ED8)
                            : (isPending
                                ? const Color(0xFFD97706)
                                : const Color(0xFFE11D48)));
                    final badgeBg = isDelivered
                        ? const Color(0xFFECFDF5)
                        : (isApproved
                            ? const Color(0xFFEFF6FF)
                            : (isPending
                                ? const Color(0xFFFFFBEB)
                                : const Color(0xFFFFF1F2)));
                    final badgeBorder = isDelivered
                        ? const Color(0xFFA7F3D0)
                        : (isApproved
                            ? const Color(0xFFBFDBFE)
                            : (isPending
                                ? const Color(0xFFFDE68A)
                                : const Color(0xFFFECDD3)));

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                r.requestCode,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              AppBadge(
                                text: isPending
                                    ? 'Menunggu'
                                    : (isApproved
                                        ? 'Disetujui'
                                        : (isDelivered
                                            ? 'Didistribusikan'
                                            : 'Ditolak')),
                                textColor: badgeColor,
                                backgroundColor: badgeBg,
                                borderColor: badgeBorder,
                                fontSize: 10,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            r.materialName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.business_rounded,
                                size: 13,
                                color: Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  r.projectName,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Volume: ',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    Text(
                                      '${r.quantity} ${r.unit}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Estimasi: ',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    Text(
                                      _formatRp(r.estimatedCost),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E3A8A),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Pemohon: ${r.requestedBy}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                r.date,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                          if (isPending) ...[
                            const Divider(height: 16, color: Color(0xFFF1F5F9)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      final index = _requests.indexWhere((item) => item.id == r.id);
                                      if (index != -1) {
                                        _requests[index] = MaterialRequestEntity(
                                          id: r.id,
                                          requestCode: r.requestCode,
                                          projectName: r.projectName,
                                          materialName: r.materialName,
                                          quantity: r.quantity,
                                          unit: r.unit,
                                          estimatedCost: r.estimatedCost,
                                          status: 'rejected',
                                          requestedBy: r.requestedBy,
                                          approvedBy: 'Admin Sistem',
                                          notes: 'Ditolak oleh manajemen',
                                          date: r.date,
                                        );
                                      }
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Pengajuan ${r.requestCode} ditolak.'),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFFE11D48),
                                    side: const BorderSide(color: Color(0xFFFECDD3)),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text('Tolak', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      final index = _requests.indexWhere((item) => item.id == r.id);
                                      if (index != -1) {
                                        _requests[index] = MaterialRequestEntity(
                                          id: r.id,
                                          requestCode: r.requestCode,
                                          projectName: r.projectName,
                                          materialName: r.materialName,
                                          quantity: r.quantity,
                                          unit: r.unit,
                                          estimatedCost: r.estimatedCost,
                                          status: 'approved',
                                          requestedBy: r.requestedBy,
                                          approvedBy: 'Admin Sistem',
                                          notes: r.notes,
                                          date: r.date,
                                        );
                                      }
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Pengajuan ${r.requestCode} berhasil disetujui.'),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: const Color(0xFF059669),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E3A8A),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text('Setujui', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
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

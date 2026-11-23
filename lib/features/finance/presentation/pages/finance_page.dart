import 'package:flutter/material.dart';
import '../../../../core/widgets/summary_widgets.dart';
import '../../../projects/data/models/project_model.dart';
import '../../../projects/domain/entities/project_entity.dart';
import '../../domain/entities/finance_transaction_entity.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  static const String routeName = '/finance';

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  // Transaksi kas (default kosong persis web: "Belum ada riwayat mutasi kas yang tercatat")
  final List<FinanceTransactionEntity> _transactions = [];

  // Data Proyek dari mock
  late final List<ProjectEntity> _projects;
  final TextEditingController _projectSearchController = TextEditingController();
  String _selectedProjectStatus = 'Semua';

  // Toggle chart: 'anggaran' vs 'arus_kas'
  String _activeChartTab = 'anggaran';

  // State Accordion Buka-Tutup (default tertutup agar mobile ringkas)
  bool _isProjectsExpanded = false;
  bool _isChartsExpanded = false;
  bool _isMaterialRequestsExpanded = false;
  bool _isCashflowExpanded = false;

  // Data Pengajuan Material Terkini (Persis Web v3: Total Rp 3.035.000)
  final List<({String material, String project, double amount, String status, String date})>
      _recentMaterialRequests = const [
    (
      material: 'Baja Ringan Truss C75.075 SNI',
      project: 'Pembangunan Gedung Kantor PT Maju Jaya',
      amount: 2550000,
      status: 'Menunggu',
      date: '19/11/2026',
    ),
    (
      material: 'Pasir Cor Super',
      project: 'Pembangunan Gedung Kantor PT Maju Jaya',
      amount: 3500000 / 10, // 350.000
      status: 'Menunggu',
      date: '18/11/2026',
    ),
    (
      material: 'Pipa PVC Wavin AW 3 inch x 4m',
      project: 'Pembangunan Gedung Kantor PT Maju Jaya',
      amount: 135000,
      status: 'Menunggu',
      date: '18/11/2026',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _projects = List.from(ProjectModel.mockProjects);
  }

  @override
  void dispose() {
    _projectSearchController.dispose();
    super.dispose();
  }

  // Filter proyek
  List<ProjectEntity> get _filteredProjects {
    final q = _projectSearchController.text.trim().toLowerCase();
    return _projects.where((p) {
      final matchesStatus = _selectedProjectStatus == 'Semua' ||
          p.status.toLowerCase() == _selectedProjectStatus.toLowerCase();
      final matchesSearch = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.code.toLowerCase().contains(q) ||
          p.location.toLowerCase().contains(q);
      return matchesStatus && matchesSearch;
    }).toList();
  }

  String _formatRp(double val, {bool compact = false}) {
    if (compact) {
      if (val >= 1000000000) {
        final b = val / 1000000000;
        return 'Rp ${b.toStringAsFixed(b.truncateToDouble() == b ? 0 : 1)} M';
      }
      if (val >= 1000000) {
        final m = val / 1000000;
        return 'Rp ${m.toStringAsFixed(m.truncateToDouble() == m ? 0 : 2)} Jt';
      }
    }
    return 'Rp ${val.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
        return const Color(0xFF1D4ED8); // blue
      case 'perencanaan':
        return const Color(0xFFD97706); // amber
      case 'tertunda':
        return const Color(0xFFE11D48); // red/rose
      case 'selesai':
        return const Color(0xFF059669); // green
      default:
        return const Color(0xFF64748B);
    }
  }

  Color _getStatusBg(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
        return const Color(0xFFEFF6FF);
      case 'perencanaan':
        return const Color(0xFFFFFBEB);
      case 'tertunda':
        return const Color(0xFFFFF1F2);
      case 'selesai':
        return const Color(0xFFECFDF5);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Perhitungan Metrik Finansial sesuai Web v3
    const totalRAB = 132000000000.0; // Rp 132 Milyar
    const totalKontrak = 152000000000.0; // Rp 152 Milyar
    const komitmenLogistik = 3035000.0; // Rp 3.035.000

    // Hitung realisasi dari mutasi pengeluaran kas tambahan jika ada
    double dynamicSpent = 0;
    double dynamicIncome = 0;
    for (final t in _transactions) {
      if (t.type == 'expense') {
        dynamicSpent += t.amount;
      } else {
        dynamicIncome += t.amount;
      }
    }

    final realisasiBiaya = dynamicSpent; // default 0 di web
    final sisaAnggaran = totalRAB - realisasiBiaya;
    final pctSpent = (realisasiBiaya / totalRAB) * 100;
    final arusKasBersih = dynamicIncome - dynamicSpent;
    final estimasiPascaPengajuan = sisaAnggaran - komitmenLogistik;

    final filteredProjects = _filteredProjects;

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
          'Keuangan Proyek',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_sync_outlined, color: Color(0xFF1D4ED8)),
            tooltip: 'Sinkronisasi Spreadsheet',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sinkronisasi mutasi kas Google Spreadsheet berhasil diperbarui.'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Color(0xFF059669),
                ),
              );
            },
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
              // ════════════════════════════════════════════════════════════════
              // 1. KOTAKAN TOTAL & METRIK FINANSIAL (Format Standar Simpro)
              // ════════════════════════════════════════════════════════════════
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Anggaran (RAB)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                'Dari 8 proyek (5 proyek aktif)',
                                style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _formatRp(totalRAB, compact: true),
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
                            label: 'Realisasi Biaya',
                            stringValue: _formatRp(realisasiBiaya, compact: true),
                            indicatorColor: const Color(0xFF059669), // green
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: AppStatusMetricBox(
                            label: 'Arus Kas Bersih',
                            stringValue: '${arusKasBersih >= 0 ? '+' : ''}${_formatRp(arusKasBersih, compact: true)}',
                            indicatorColor: const Color(0xFF6366F1), // indigo
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: AppStatusMetricBox(
                            label: 'Komitmen Logistik',
                            stringValue: _formatRp(komitmenLogistik, compact: true),
                            indicatorColor: const Color(0xFFD97706), // amber
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ════════════════════════════════════════════════════════════════
              // 2. STATUS PENGGUNAAN ANGGARAN KESELURUHAN (Sesuai Web)
              // ════════════════════════════════════════════════════════════════
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status Penggunaan Anggaran',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Penggunaan anggaran masih berada dalam batas wajar dan aman.',
                      style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 10),

                    // Badges Kondisi & Persentase Terpakai
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFA7F3D0)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              CircleAvatar(radius: 3, backgroundColor: Color(0xFF059669)),
                              SizedBox(width: 4),
                              Text(
                                'Kondisi: Terkendali',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF059669),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Text(
                            '${pctSpent.toStringAsFixed(1)}% Terpakai',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (pctSpent / 100).clamp(0.0, 1.0),
                        backgroundColor: const Color(0xFFF1F5F9),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Footnote Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Kontrak: ${_formatRp(totalKontrak, compact: true)} • Sisa: ${_formatRp(sisaAnggaran, compact: true)}',
                            style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Est. Pasca: ${_formatRp(estimasiPascaPengajuan, compact: true)}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ════════════════════════════════════════════════════════════════
              // 3. ACCORDION 1: REALISASI ANGGARAN PER PROYEK (8 Proyek)
              // ════════════════════════════════════════════════════════════════
              _buildAccordionCard(
                icon: Icons.business_center_outlined,
                iconColor: const Color(0xFF1D4ED8),
                iconBg: const Color(0xFFEFF6FF),
                title: 'Realisasi Anggaran per Proyek',
                subtitle: 'Evaluasi alokasi RAB vs progres fisik lapangan',
                badgeText: '${_projects.length} Proyek',
                badgeColor: const Color(0xFF1D4ED8),
                badgeBg: const Color(0xFFEFF6FF),
                isExpanded: _isProjectsExpanded,
                onTap: () => setState(() => _isProjectsExpanded = !_isProjectsExpanded),
                children: [
                  // Filter & Search Box
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _projectSearchController,
                          onChanged: (_) => setState(() {}),
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: 'Cari proyek atau lokasi...',
                            hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                            prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF94A3B8)),
                            suffixIcon: _projectSearchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, size: 16),
                                    onPressed: () {
                                      _projectSearchController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedProjectStatus,
                          isExpanded: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF1D4ED8), width: 1.5),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF1E293B),
                            fontWeight: FontWeight.w600,
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: Color(0xFF64748B),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Semua', child: Text('-- Semua Status Proyek --')),
                            DropdownMenuItem(value: 'Aktif', child: Text('Status: Aktif')),
                            DropdownMenuItem(value: 'Perencanaan', child: Text('Status: Perencanaan')),
                            DropdownMenuItem(value: 'Tertunda', child: Text('Status: Tertunda')),
                            DropdownMenuItem(value: 'Selesai', child: Text('Status: Selesai')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedProjectStatus = val);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // List Proyek
                  if (filteredProjects.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      child: const Text('Tidak ada proyek yang sesuai filter.', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                    )
                  else
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredProjects.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final p = filteredProjects[i];
                        final statusColor = _getStatusColor(p.status);
                        final statusBg = _getStatusBg(p.status);

                        // Di web v3 realisasi terpakai saat ini 0
                        final rab = p.budget;
                        const realisasi = 0.0;
                        final sisa = rab - realisasi;
                        const costPct = 0.0;
                        final physicalPct = p.progress;

                        return Container(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p.name,
                                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${p.code} • ${p.location}',
                                          style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                                    child: Text(
                                      p.status[0].toUpperCase() + p.status.substring(1),
                                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: statusColor),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Info Alokasi RAB & Realisasi
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('RAB (ALOKASI)', style: TextStyle(fontSize: 9, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 1),
                                      Text(_formatRp(rab), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text('SISA ANGGARAN', style: TextStyle(fontSize: 9, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 1),
                                      Text(_formatRp(sisa), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Dual Capaian Biaya vs Fisik
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Biaya ${costPct.toStringAsFixed(1)}%',
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)),
                                  ),
                                  Text(
                                    'Fisik ${physicalPct.toStringAsFixed(0)}%',
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Stack(
                                children: [
                                  Container(height: 4, width: double.infinity, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2))),
                                  FractionallySizedBox(
                                    widthFactor: (physicalPct / 100).clamp(0.0, 1.0),
                                    child: Container(height: 4, decoration: BoxDecoration(color: const Color(0xFF94A3B8), borderRadius: BorderRadius.circular(2))),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: (costPct / 100).clamp(0.0, 1.0),
                                    child: Container(height: 4, decoration: BoxDecoration(color: const Color(0xFF1D4ED8), borderRadius: BorderRadius.circular(2))),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: 14),

              // ════════════════════════════════════════════════════════════════
              // 4. ACCORDION 2: VISUALISASI FINANSIAL & KOMPOSISI
              // ════════════════════════════════════════════════════════════════
              _buildAccordionCard(
                icon: Icons.pie_chart_outline_rounded,
                iconColor: const Color(0xFF059669),
                iconBg: const Color(0xFFECFDF5),
                title: 'Visualisasi Finansial & Komposisi',
                subtitle: 'Grafik alokasi RAB & distribusi pengeluaran',
                badgeText: 'Grafik',
                badgeColor: const Color(0xFF059669),
                badgeBg: const Color(0xFFECFDF5),
                isExpanded: _isChartsExpanded,
                onTap: () => setState(() => _isChartsExpanded = !_isChartsExpanded),
                children: [
                  // Toggle Button
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _activeChartTab = 'anggaran'),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: _activeChartTab == 'anggaran' ? const Color(0xFF1D4ED8) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Anggaran Proyek',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: _activeChartTab == 'anggaran' ? Colors.white : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _activeChartTab = 'arus_kas'),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: _activeChartTab == 'arus_kas' ? const Color(0xFF1D4ED8) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Arus Kas 6 Bulan',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: _activeChartTab == 'arus_kas' ? Colors.white : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  if (_activeChartTab == 'anggaran') ...[
                    // Grafik Batang Distribusi RAB per Proyek
                    const Text('Distribusi Alokasi RAB per Proyek (Milyar Rp):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                    const SizedBox(height: 10),
                    ..._projects.map((p) {
                      final valM = p.budget / 1000000000;
                      const maxM = 50.0;
                      final factor = (valM / maxM).clamp(0.05, 1.0);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${p.code} - ${p.name}',
                                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  'Rp ${valM.toStringAsFixed(1)} M',
                                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: factor,
                                backgroundColor: const Color(0xFFF1F5F9),
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1D4ED8)),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        CircleAvatar(radius: 4, backgroundColor: Color(0xFF1D4ED8)),
                        SizedBox(width: 4),
                        Text('Alokasi Anggaran (RAB)', style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B))),
                        SizedBox(width: 12),
                        CircleAvatar(radius: 4, backgroundColor: Color(0xFF059669)),
                        SizedBox(width: 4),
                        Text('Realisasi Terpakai (Rp 0)', style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B))),
                      ],
                    ),
                  ] else ...[
                    // Arus Kas 6 Bulan
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Bulan', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                              Text('Pemasukan', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                              Text('Pengeluaran', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFFE11D48))),
                            ],
                          ),
                          const Divider(height: 12, color: Color(0xFFE2E8F0)),
                          ...['Jun 2026', 'Jul 2026', 'Agu 2026', 'Sep 2026', 'Okt 2026', 'Nov 2026'].map((m) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(m, style: const TextStyle(fontSize: 11, color: Color(0xFF334155))),
                                  const Text('Rp 0', style: TextStyle(fontSize: 11, color: Color(0xFF059669), fontWeight: FontWeight.w600)),
                                  const Text('Rp 0', style: TextStyle(fontSize: 11, color: Color(0xFFE11D48), fontWeight: FontWeight.w600)),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],

                  const Divider(height: 24, color: Color(0xFFE2E8F0)),

                  // Komposisi Pengeluaran (Persis Donut Web)
                  const Text('Komposisi Alokasi & Pengeluaran:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  const SizedBox(height: 10),
                  _buildCompositionRow('Realisasi Biaya Terpakai', 'Rp 0', '0.0%', const Color(0xFF1D4ED8)),
                  const SizedBox(height: 6),
                  _buildCompositionRow('Sisa Anggaran Tersedia', 'Rp 132.000.000.000', '99.99%', const Color(0xFF059669)),
                  const SizedBox(height: 6),
                  _buildCompositionRow('Komitmen Material', 'Rp 3.035.000', '0.01%', const Color(0xFFD97706)),
                ],
              ),
              const SizedBox(height: 14),

              // ════════════════════════════════════════════════════════════════
              // 5. ACCORDION 3: PENGAJUAN MATERIAL TERKINI (3 Item)
              // ════════════════════════════════════════════════════════════════
              _buildAccordionCard(
                icon: Icons.inventory_2_outlined,
                iconColor: const Color(0xFFD97706),
                iconBg: const Color(0xFFFFFBEB),
                title: 'Pengajuan Material Terkini',
                subtitle: 'Permintaan logistik & komitmen material',
                badgeText: '3 Item • Rp 3,03 Jt',
                badgeColor: const Color(0xFFD97706),
                badgeBg: const Color(0xFFFFFBEB),
                isExpanded: _isMaterialRequestsExpanded,
                onTap: () => setState(() => _isMaterialRequestsExpanded = !_isMaterialRequestsExpanded),
                children: [
                  ..._recentMaterialRequests.map((req) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFBEB),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.shopping_cart_outlined, size: 16, color: Color(0xFFD97706)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  req.material,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  req.project,
                                  style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFFBEB),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: const Color(0xFFFDE68A)),
                                      ),
                                      child: Text(
                                        req.status,
                                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFB45309)),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      req.date,
                                      style: const TextStyle(fontSize: 9.5, color: Color(0xFF94A3B8)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _formatRp(req.amount),
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 14),

              // ════════════════════════════════════════════════════════════════
              // 6. ACCORDION 4: DAFTAR MUTASI KAS TERKINI
              // ════════════════════════════════════════════════════════════════
              _buildAccordionCard(
                icon: Icons.receipt_long_outlined,
                iconColor: const Color(0xFF6366F1),
                iconBg: const Color(0xFFEEF2FF),
                title: 'Daftar Mutasi Kas Terkini',
                subtitle: 'Catatan transaksi pemasukan & pengeluaran kas',
                badgeText: '${_transactions.length} Mutasi',
                badgeColor: const Color(0xFF6366F1),
                badgeBg: const Color(0xFFEEF2FF),
                isExpanded: _isCashflowExpanded,
                onTap: () => setState(() => _isCashflowExpanded = !_isCashflowExpanded),
                children: [
                  if (_transactions.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.account_balance_wallet_outlined, size: 36, color: Color(0xFFCBD5E1)),
                          const SizedBox(height: 8),
                          const Text(
                            'Belum ada riwayat mutasi kas yang tercatat.',
                            style: TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Seluruh mutasi kas otomatis tersinkronisasi dari Google Spreadsheet.',
                            style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else ...[
                    ..._transactions.map((t) {
                      final isIncome = t.type == 'income';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isIncome ? const Color(0xFFECFDF5) : const Color(0xFFFFF1F2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                color: isIncome ? const Color(0xFF059669) : const Color(0xFFE11D48),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(t.description, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                  const SizedBox(height: 2),
                                  Text('${t.projectName} • ${t.date}', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                                ],
                              ),
                            ),
                            Text(
                              '${isIncome ? '+' : '-'}${_formatRp(t.amount)}',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: isIncome ? const Color(0xFF059669) : const Color(0xFFE11D48),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  // REUSABLE ACCORDION CARD WIDGET
  // ════════════════════════════════════════════════════════════════
  Widget _buildAccordionCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required Color badgeBg,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          // Header Card
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 18, color: iconColor),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          isExpanded ? 'Ketuk untuk menutup menu' : subtitle,
                          style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: badgeColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF64748B),
                    size: 22,
                  ),
                ],
              ),
            ),
          ),

          // Konten Saat Dibuka
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompositionRow(String label, String value, String pct, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF334155)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
            child: Text(pct, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: color)),
          ),
        ],
      ),
    );
  }
}

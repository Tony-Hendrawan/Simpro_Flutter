import 'package:flutter/material.dart';
import '../../../../core/widgets/summary_widgets.dart';

class ReportsExportPage extends StatefulWidget {
  const ReportsExportPage({super.key});

  static const String routeName = '/reports-export';

  @override
  State<ReportsExportPage> createState() => _ReportsExportPageState();
}

class _ReportsExportPageState extends State<ReportsExportPage> {
  String _selectedModule = 'proyek'; // 'proyek', 'keuangan', 'material', 'progress'
  String _selectedProject = 'all'; // 'all' or project name
  String _selectedFormat = 'excel'; // 'excel', 'pdf'
  bool _isGenerating = false;

  final List<({String title, String desc, IconData icon, String type, Color color, Color bg})> _modules = const [
    (
      title: 'Laporan Proyek',
      desc: 'Status pengerjaan, nilai kontrak, alokasi RAB, dan realisasi biaya.',
      icon: Icons.format_list_bulleted_rounded,
      type: 'proyek',
      color: Color(0xFF1D4ED8),
      bg: Color(0xFFEFF6FF),
    ),
    (
      title: 'Laporan Keuangan',
      desc: 'Arus kas keluar-masuk, rincian biaya per kategori, dan sisa anggaran.',
      icon: Icons.account_balance_wallet_outlined,
      type: 'keuangan',
      color: Color(0xFF059669),
      bg: Color(0xFFECFDF5),
    ),
    (
      title: 'Laporan Material',
      desc: 'Mutasi logistik masuk/keluar, stok kritis, dan pengajuan lapangan.',
      icon: Icons.inventory_2_outlined,
      type: 'material',
      color: Color(0xFFD97706),
      bg: Color(0xFFFFFBEB),
    ),
    (
      title: 'Laporan Progres Fisik',
      desc: 'Riwayat capaian persentase pengerjaan berkala mingguan/bulanan.',
      icon: Icons.trending_up_rounded,
      type: 'progress',
      color: Color(0xFF4F46E5),
      bg: Color(0xFFEEF2FF),
    ),
  ];

  final List<({String id, String name})> _projectOptions = const [
    (id: 'all', name: 'Semua Proyek (Akumulatif Seluruh Proyek)'),
    (id: '1', name: 'P001 - Pembangunan Gedung Kantor PT Maju Jaya'),
    (id: '2', name: 'P002 - Renovasi Hotel Bintang Lima Nusantara'),
    (id: '3', name: 'P003 - Pembangunan Jembatan Sungai Ciliwung'),
    (id: '4', name: 'P004 - Perumahan Green Valley Residence'),
    (id: '5', name: 'P005 - Pembangunan Gudang Logistik Cikupa'),
    (id: '6', name: 'P006 - Pembangunan Masjid Al-Ikhlas'),
  ];

  final List<({String user, String action, String time})> _recentExports = [
    (user: 'Admin Sistem', action: 'Mengunduh Rekapitulasi Keuangan (.xlsx)', time: '10 menit lalu'),
    (user: 'Direktur Utama', action: 'Mengunduh Laporan Progres Fisik (.pdf)', time: '2 jam lalu'),
    (user: 'Staf Logistik', action: 'Mengunduh Buku Stok Gudang (.xlsx)', time: 'Kemarin, 14:20 WIB'),
  ];

  Future<void> _triggerDownload() async {
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isGenerating = false);

    final moduleLabel = _modules.firstWhere((m) => m.type == _selectedModule).title;
    final ext = _selectedFormat == 'excel' ? 'xlsx' : 'pdf';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text('Berkas $moduleLabel (.$ext) berhasil digenerate dan diunduh.')),
          ],
        ),
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Generate & Ekspor Laporan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ekspor & Rekapitulasi Laporan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Unduh rekapitulasi data proyek, arus kas keuangan, pengadaan material, dan perkembangan fisik dalam format Excel (.xlsx) atau PDF.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 1. Pilih Modul Laporan
              const Text(
                '1. Pilih Modul Laporan',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 10),

              // Module Selection Cards
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _modules.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final m = _modules[index];
                  final isSelected = _selectedModule == m.type;

                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _selectedModule = m.type),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFFE2E8F0),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF1D4ED8) : m.bg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(m.icon, color: isSelected ? Colors.white : m.color, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                const SizedBox(height: 2),
                                Text(m.desc, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle_rounded, color: Color(0xFF1D4ED8), size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // 2. Cakupan Proyek (Sesuai Web v3)
              const Text(
                '2. Cakupan Proyek',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedProject,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                    items: _projectOptions.map((opt) {
                      return DropdownMenuItem(
                        value: opt.id,
                        child: Text(
                          opt.name,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedProject = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. Format Dokumen Ekspor
              const Text(
                '3. Format Dokumen Ekspor',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => setState(() => _selectedFormat = 'excel'),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _selectedFormat == 'excel' ? const Color(0xFFECFDF5) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedFormat == 'excel' ? const Color(0xFF059669) : const Color(0xFFE2E8F0),
                            width: _selectedFormat == 'excel' ? 1.5 : 1,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.table_chart_rounded, color: Color(0xFF059669), size: 24),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Spreadsheet (.xlsx)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                  Text('Microsoft Excel', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => setState(() => _selectedFormat = 'pdf'),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _selectedFormat == 'pdf' ? const Color(0xFFFFF1F2) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedFormat == 'pdf' ? const Color(0xFFE11D48) : const Color(0xFFE2E8F0),
                            width: _selectedFormat == 'pdf' ? 1.5 : 1,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFE11D48), size: 24),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Cetak Resmi (.pdf)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                  Text('Format Kop CV AG', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Action Button (Unduh Laporan)
              SizedBox(
                width: double.infinity,
                child: AppPrimaryButton(
                  label: 'UNDUH BERKAS LAPORAN',
                  icon: Icons.download_rounded,
                  isLoading: _isGenerating,
                  onPressed: _triggerDownload,
                ),
              ),
              const SizedBox(height: 24),

              // Standar Laporan Eksekutif (Persis Sidebar Web v3)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.verified_outlined, size: 18, color: Color(0xFF1D4ED8)),
                        SizedBox(width: 8),
                        Text(
                          'Standar Dokumen CV Arthamas Graha',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Semua laporan PDF resmi otomatis menyertakan kop surat perusahaan, stempel digital, paraf pengawas lapangan, dan ringkasan audit realisasi anggaran.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF334155), height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Aktivitas Ekspor Terkini
              const Text(
                'Aktivitas Ekspor Terkini',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 10),

              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _recentExports.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final e = _recentExports[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.user, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                              const SizedBox(height: 2),
                              Text(e.action, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        Text(e.time, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
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

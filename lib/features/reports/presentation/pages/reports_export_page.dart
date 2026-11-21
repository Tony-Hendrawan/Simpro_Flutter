import 'package:flutter/material.dart';

class ReportsExportPage extends StatefulWidget {
  const ReportsExportPage({super.key});

  static const String routeName = '/reports-export';

  @override
  State<ReportsExportPage> createState() => _ReportsExportPageState();
}

class _ReportsExportPageState extends State<ReportsExportPage> {
  String _selectedModule = 'proyek';
  String _selectedProject = 'all';
  String _selectedFormat = 'excel';
  bool _isGenerating = false;

  final List<({String title, String desc, IconData icon, String type, Color color, Color bg})>
      _modules = const [
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
      desc: 'Rekapitulasi pemasukan, pengeluaran kas, dan sisa anggaran.',
      icon: Icons.account_balance_wallet_outlined,
      type: 'keuangan',
      color: Color(0xFF059669),
      bg: Color(0xFFECFDF5),
    ),
    (
      title: 'Laporan Pengadaan Material',
      desc: 'Permintaan, logistik, kuantitas stok, estimasi biaya, dan status kirim.',
      icon: Icons.inventory_2_outlined,
      type: 'material',
      color: Color(0xFFD97706),
      bg: Color(0xFFFFFBEB),
    ),
    (
      title: 'Laporan Perkembangan Fisik',
      desc: 'Rincian laporan persentase pengerjaan proyek dan catatan lapangan.',
      icon: Icons.trending_up_rounded,
      type: 'progress',
      color: Color(0xFF4F46E5),
      bg: Color(0xFFEEF2FF),
    ),
  ];

  final List<({String id, String name})> _projectOptions = const [
    (id: 'all', name: 'Semua Proyek (Akumulatif Seluruh Proyek)'),
    (id: '1', name: 'P001 – Pembangunan Gedung Kantor PT Maju Jaya'),
    (id: '2', name: 'P002 – Renovasi Hotel Bintang Lima Nusantara'),
    (id: '3', name: 'P003 – Pembangunan Jembatan Sungai Ciliwung'),
    (id: '4', name: 'P004 – Perumahan Green Valley Residence'),
    (id: '5', name: 'P005 – Pembangunan Gudang Logistik Cikupa'),
    (id: '6', name: 'P006 – Pembangunan Masjid Al-Ikhlas'),
  ];


  Future<void> _triggerDownload() async {
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isGenerating = false);

    final moduleLabel = _modules.firstWhere((m) => m.type == _selectedModule).title;
    final ext = _selectedFormat == 'excel' ? 'xlsx' : 'pdf';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text('$moduleLabel (.$ext) berhasil diunduh.')),
            ],
          ),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
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
              // ── Langkah 1: Pilih Modul ───────────────────────────────────
              _sectionLabel('Pilih Modul Laporan', '1'),
              const SizedBox(height: 10),

              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _modules.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final m = _modules[i];
                  final selected = _selectedModule == m.type;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedModule = m.type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: selected ? m.bg : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected ? m.color : const Color(0xFFE2E8F0),
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: selected ? m.color : m.bg,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Icon(m.icon,
                                color: selected ? Colors.white : m.color, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m.title,
                                    style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                        color: selected ? m.color : const Color(0xFF0F172A))),
                                const SizedBox(height: 2),
                                Text(m.desc,
                                    style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                              ],
                            ),
                          ),
                          if (selected)
                            Icon(Icons.check_circle_rounded, color: m.color, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),

              // ── Langkah 2: Cakupan Proyek ────────────────────────────────
              _sectionLabel('Cakupan Proyek', '2'),
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
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                    items: _projectOptions.map((opt) {
                      return DropdownMenuItem(
                        value: opt.id,
                        child: Text(opt.name, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedProject = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // ── Langkah 3: Format Berkas ─────────────────────────────────
              _sectionLabel('Format Berkas', '3'),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(child: _formatCard('excel', Icons.table_chart_rounded,
                      'Spreadsheet (.xlsx)', 'Analisis di Excel / Sheets', const Color(0xFF059669), const Color(0xFFECFDF5))),
                  const SizedBox(width: 10),
                  Expanded(child: _formatCard('pdf', Icons.picture_as_pdf_rounded,
                      'Cetak Resmi (.pdf)', 'Kop & stempel perusahaan', const Color(0xFFE11D48), const Color(0xFFFFF1F2))),
                ],
              ),
              const SizedBox(height: 20),

              // ── Tombol Unduh ─────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isGenerating ? null : _triggerDownload,
                  icon: _isGenerating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.download_rounded, size: 20),
                  label: Text(
                    _isGenerating ? 'Memproses...' : 'Unduh Laporan',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // ── Info Standar Dokumen ─────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.verified_rounded, size: 18, color: Color(0xFF1D4ED8)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Laporan PDF resmi otomatis menyertakan kop surat perusahaan, stempel digital, paraf pengawas lapangan, dan ringkasan audit realisasi anggaran.',
                        style: TextStyle(fontSize: 11, color: Color(0xFF334155), height: 1.45),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label, String step) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF1D4ED8),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            step,
            style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
              fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
      ],
    );
  }

  Widget _formatCard(
    String type,
    IconData icon,
    String title,
    String subtitle,
    Color accentColor,
    Color selectedBg,
  ) {
    final selected = _selectedFormat == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedFormat = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? selectedBg : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? accentColor : const Color(0xFFE2E8F0),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: accentColor, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: selected ? accentColor : const Color(0xFF0F172A))),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

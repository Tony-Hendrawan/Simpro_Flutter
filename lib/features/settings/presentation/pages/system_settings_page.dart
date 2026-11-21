import 'package:flutter/material.dart';

import '../../../finance/presentation/pages/finance_page.dart';
import '../../../materials/presentation/pages/materials_page.dart';
import '../../../users/presentation/pages/users_management_page.dart';

class SystemSettingsPage extends StatefulWidget {
  const SystemSettingsPage({super.key});

  static const String routeName = '/settings';

  @override
  State<SystemSettingsPage> createState() => _SystemSettingsPageState();
}

class _SystemSettingsPageState extends State<SystemSettingsPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  bool _siteSurveyPhotoRequired = true;
  bool _isSaving = false;

  // Kontrol buka/tutup menu agar tampilan ringkas (semua default tertutup)
  bool _isProfileExpanded = false;
  bool _isLetterheadExpanded = false;
  bool _isModulesExpanded = false;
  bool _isBackupExpanded = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'CV Arthamas Graha');
    _emailController = TextEditingController(text: 'info@arthamasgraha.com');
    _phoneController = TextEditingController(text: '021-5551234');
    _addressController = TextEditingController(
      text: 'Jl. Jenderal Sudirman No. 12, Jakarta Selatan',
    );

    _nameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _phoneController.addListener(() => setState(() {}));
    _addressController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text('Pengaturan sistem dan profil perusahaan berhasil disimpan.'),
              ),
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
    final companyName = _nameController.text.trim().isEmpty ? 'CV ARTHAMAS GRAHA' : _nameController.text.trim();
    final address = _addressController.text.trim().isEmpty
        ? 'Jl. Jenderal Sudirman No. 12, Jakarta Selatan'
        : _addressController.text.trim();
    final phone = _phoneController.text.trim().isEmpty ? '021-5551234' : _phoneController.text.trim();
    final email = _emailController.text.trim().isEmpty ? 'info@arthamasgraha.com' : _emailController.text.trim();

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
          'Pengaturan Sistem',
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Ringkasan Halaman
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Pengaturan Sistem & Profil Perusahaan',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFBFDBFE)),
                          ),
                          child: const Text(
                            'v1.0.0 (Stabil)',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D4ED8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Konfigurasi identitas resmi perusahaan, kontak operasional, dan informasi pada kop dokumen SIMPRO.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.4,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ════════════════════════════════════════════════════════════════
              // 1. MENU: PROFIL & IDENTITAS PERUSAHAAN (Dapat Dilipat / Buka)
              // ════════════════════════════════════════════════════════════════
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    // Header Menu
                    InkWell(
                      onTap: () => setState(() => _isProfileExpanded = !_isProfileExpanded),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
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
                                Icons.business_rounded,
                                size: 18,
                                color: Color(0xFF1D4ED8),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Profil & Identitas Perusahaan',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            Icon(
                              _isProfileExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: const Color(0xFF64748B),
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Konten Formulir (Muncul saat menu dibuka)
                    if (_isProfileExpanded) ...[
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Nama Resmi Perusahaan *'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _nameController,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
                                decoration: _inputDecoration('Contoh: CV Arthamas Graha'),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty) ? 'Nama resmi perusahaan wajib diisi' : null,
                              ),
                              const SizedBox(height: 12),

                              _buildLabel('Alamat Email Perusahaan *'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
                                decoration: _inputDecoration('Contoh: info@arthamasgraha.com'),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return 'Email perusahaan wajib diisi';
                                  if (!v.contains('@')) return 'Format email tidak valid';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              _buildLabel('Nomor Telepon Kantor *'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
                                decoration: _inputDecoration('Contoh: 021-5551234'),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty) ? 'Nomor telepon kantor wajib diisi' : null,
                              ),
                              const SizedBox(height: 12),

                              _buildLabel('Alamat Kantor Operasional *'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _addressController,
                                maxLines: 3,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
                                decoration: _inputDecoration(
                                  'Tuliskan alamat lengkap kantor operasional atau kantor pusat...',
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty) ? 'Alamat kantor operasional wajib diisi' : null,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Alamat ini akan otomatis dicetak pada bagian kepala dokumen laporan dan formulir berita acara.',
                                style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                              ),
                              const SizedBox(height: 14),

                              // ── Sub-Menu Terpadu: Pratinjau Kop Dokumen ──
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () => setState(() => _isLetterheadExpanded = !_isLetterheadExpanded),
                                      borderRadius: BorderRadius.circular(10),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.receipt_long_rounded,
                                              size: 16,
                                              color: Color(0xFF4F46E5),
                                            ),
                                            const SizedBox(width: 8),
                                            const Expanded(
                                              child: Text(
                                                'Pratinjau Kop Dokumen Cetak',
                                                style: TextStyle(
                                                  fontSize: 11.5,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF334155),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              _isLetterheadExpanded ? 'Tutup' : 'Lihat',
                                              style: const TextStyle(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1D4ED8),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Icon(
                                              _isLetterheadExpanded
                                                  ? Icons.keyboard_arrow_up_rounded
                                                  : Icons.keyboard_arrow_down_rounded,
                                              size: 18,
                                              color: const Color(0xFF1D4ED8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Sub-tampilan Kop Visual
                                    if (_isLetterheadExpanded) ...[
                                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    companyName.toUpperCase(),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 12.5,
                                                      fontWeight: FontWeight.w900,
                                                      letterSpacing: 0.6,
                                                      color: Color(0xFF0F172A),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 3),
                                                  Text(
                                                    address,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(fontSize: 10, color: Color(0xFF475569)),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'Telp: $phone  •  Email: $email',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 9,
                                                      fontFamily: 'monospace',
                                                      color: Color(0xFF64748B),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Container(height: 2, width: double.infinity, color: const Color(0xFFCBD5E1)),
                                                  const SizedBox(height: 1.5),
                                                  Container(height: 0.8, width: double.infinity, color: const Color(0xFFCBD5E1)),
                                                  const SizedBox(height: 5),
                                                  const Text(
                                                    'SISTEM INFORMASI MANAJEMEN PROYEK (SIMPRO) • V1.0.0',
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      fontWeight: FontWeight.bold,
                                                      letterSpacing: 0.8,
                                                      color: Color(0xFF94A3B8),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Kebijakan Validasi Lapangan
                              _buildLabel('Kebijakan Validasi Lapangan'),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: _siteSurveyPhotoRequired,
                                        activeColor: const Color(0xFF1D4ED8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                        onChanged: (val) {
                                          setState(() => _siteSurveyPhotoRequired = val ?? false);
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() => _siteSurveyPhotoRequired = !_siteSurveyPhotoRequired);
                                            },
                                            child: const Text(
                                              'Wajibkan Lampiran Foto pada Survei Lokasi (Site Survey)',
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1E293B),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          const Text(
                                            'Jika diaktifkan, pengawas wajib melampirkan minimal 1 berkas foto/dokumen saat mengajukan survei baru.',
                                            style: TextStyle(fontSize: 10.5, height: 1.35, color: Color(0xFF64748B)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Tombol Simpan
                              Row(
                                children: [
                                  const Icon(Icons.history_rounded, size: 14, color: Color(0xFF94A3B8)),
                                  const SizedBox(width: 6),
                                  const Expanded(
                                    child: Text(
                                      'Tersimpan otomatis ke database konfigurasi.',
                                      style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: _isSaving ? null : _handleSave,
                                    icon: _isSaving
                                        ? const SizedBox(
                                            width: 14,
                                            height: 14,
                                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                          )
                                        : const Icon(Icons.save_rounded, size: 15),
                                    label: const Text(
                                      'Simpan Perubahan',
                                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1D4ED8),
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor: const Color(0xFF94A3B8),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      elevation: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ════════════════════════════════════════════════════════════════
              // 2. MENU TERPADU: INTEGRASI DATA & HAK AKSES (1 Menu -> 3 Sub-Menu)
              // ════════════════════════════════════════════════════════════════
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    // Header Menu
                    InkWell(
                      onTap: () => setState(() => _isModulesExpanded = !_isModulesExpanded),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.hub_outlined,
                                size: 18,
                                color: Color(0xFF059669),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Integrasi Data & Hak Akses',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            Icon(
                              _isModulesExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: const Color(0xFF64748B),
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Sub-Menu: Muncul saat dibuka
                    if (_isModulesExpanded) ...[
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            // Sub 1: Logistik
                            _buildModuleLink(
                              icon: Icons.inventory_2_outlined,
                              iconColor: const Color(0xFFD97706),
                              iconBg: const Color(0xFFFFFBEB),
                              title: 'Integrasi Spreadsheet Logistik',
                              subtitle: 'Sinkronisasi stok material & pengadaan gudang',
                              onTap: () => Navigator.pushNamed(context, MaterialsPage.routeName),
                            ),
                            const SizedBox(height: 8),

                            // Sub 2: Keuangan
                            _buildModuleLink(
                              icon: Icons.account_balance_wallet_outlined,
                              iconColor: const Color(0xFF059669),
                              iconBg: const Color(0xFFECFDF5),
                              title: 'Integrasi Spreadsheet Keuangan',
                              subtitle: 'Alur kas proyek, termin pembayaran & realisasi RAB',
                              onTap: () => Navigator.pushNamed(context, FinancePage.routeName),
                            ),
                            const SizedBox(height: 8),

                            // Sub 3: Pengguna
                            _buildModuleLink(
                              icon: Icons.manage_accounts_outlined,
                              iconColor: const Color(0xFF4F46E5),
                              iconBg: const Color(0xFFEEF2FF),
                              title: 'Manajemen Hak Akses Pengguna',
                              subtitle: 'Pengaturan akun tim & hak akses peran (RBAC)',
                              onTap: () => Navigator.pushNamed(context, UsersManagementPage.routeName),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ════════════════════════════════════════════════════════════════
              // 3. MENU TERPADU: PENCADANGAN DATABASE & PEMELIHARAAN SISTEM
              // ════════════════════════════════════════════════════════════════
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    // Header Menu
                    InkWell(
                      onTap: () => setState(() => _isBackupExpanded = !_isBackupExpanded),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFBEB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.storage_rounded,
                                size: 18,
                                color: Color(0xFFD97706),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Pencadangan Database (.sql)',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            Icon(
                              _isBackupExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: const Color(0xFF64748B),
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Sub-Menu: Muncul saat dibuka
                    if (_isBackupExpanded) ...[
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Unduh snapshot cadangan database dalam format SQL nyata untuk keperluan arsip offline atau pemulihan darurat ("Disaster Recovery").',
                              style: TextStyle(fontSize: 11, color: Color(0xFF475569), height: 1.4),
                            ),
                            const SizedBox(height: 12),

                            // Sub-Tombol Unduh SQL
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.download_rounded, size: 16),
                                label: const Text(
                                  'Unduh Backup SQL (.sql)',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD97706),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Mengunduh backup database SIMPRO_backup.sql...'),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Color(0xFFD97706),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Sub-Box: Otomasi cPanel Cron
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.terminal_rounded, size: 14, color: Color(0xFF1D4ED8)),
                                      SizedBox(width: 6),
                                      Text(
                                        'Otomasi cPanel Cron:',
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF334155),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: const Color(0xFFE2E8F0)),
                                    ),
                                    child: const Text(
                                      'mysqldump -u user -p db | gzip > backup.sql.gz',
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        fontFamily: 'monospace',
                                        color: Color(0xFF475569),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

  Widget _buildModuleLink({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.bold,
        color: Color(0xFF334155),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
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
    );
  }
}

import 'package:flutter/material.dart';

// ── Settings Header ──
class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Pengaturan Sistem & Profil Perusahaan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Konfigurasi identitas resmi perusahaan, kontak operasional, dan informasi pada kop dokumen SIMPRO.',
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Letterhead Preview Card ──
class LetterheadPreviewCard extends StatelessWidget {
  final String companyName;
  final String address;
  final String phone;
  final String email;

  const LetterheadPreviewCard({
    super.key,
    this.companyName = 'CV ARTHAMAS GRAHA',
    this.address = 'Jl. Jenderal Sudirman No. 12, Jakarta Selatan',
    this.phone = '021-5551234',
    this.email = 'info@arthamasgraha.com',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.description_outlined, color: Color(0xFF0F172A), size: 20),
              SizedBox(width: 12),
              Text(
                'Pratinjau Kop Dokumen',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Text(
                  companyName.trim().isEmpty ? 'CV ARTHAMAS GRAHA' : companyName.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address.trim().isEmpty ? 'Jl. Jenderal Sudirman No. 12, Jakarta Selatan' : address,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                ),
                const SizedBox(height: 2),
                Text(
                  'Telp: ${phone.trim().isEmpty ? "021-5551234" : phone} • Email: ${email.trim().isEmpty ? "info@arthamasgraha.com" : email}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Related Modules Card ──
class RelatedModulesCard extends StatelessWidget {
  const RelatedModulesCard({super.key});

  @override
  Widget build(BuildContext context) {
    const modules = [
      (title: 'Integrasi Spreadsheet Logistik', icon: Icons.table_chart_outlined),
      (title: 'Integrasi Spreadsheet Keuangan', icon: Icons.account_balance_wallet_outlined),
      (title: 'Manajemen Hak Akses Pengguna', icon: Icons.admin_panel_settings_outlined),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.link_rounded, color: Color(0xFF0F172A), size: 20),
              SizedBox(width: 12),
              Text(
                'Pengaturan Modul Terkait',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: modules.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final module = modules[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Icon(module.icon, color: const Color(0xFF0F172A), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        module.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 20),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


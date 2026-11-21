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
                    letterSpacing: 0.5,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'KONTRAKTOR UMUM · DESAIN INTERIOR · MEKANIKAL & ELEKTRIKAL',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Color(0xFF1D4ED8),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  address.trim().isEmpty ? 'Jl. Jenderal Sudirman No. 12, Jakarta Selatan' : address,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Telp: ${phone.trim().isEmpty ? '021-5551234' : phone} · Email: ${email.trim().isEmpty ? 'info@arthamasgraha.com' : email}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  height: 3,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: const Color(0xFF0F172A),
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
      (icon: Icons.people_outline_rounded, title: 'Manajemen Pengguna & Hak Akses (RBAC)'),
      (icon: Icons.shield_outlined, title: 'Kebijakan Keamanan & Password'),
      (icon: Icons.notifications_none_rounded, title: 'Preferensi Notifikasi & Email'),
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
              Icon(Icons.hub_outlined, color: Color(0xFF0F172A), size: 20),
              SizedBox(width: 12),
              Text(
                'Integrasi Data & Hak Akses',
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

// ── Validation Policy Card (v2 Kebijakan Validasi Lapangan) ──
class ValidationPolicyCard extends StatefulWidget {
  const ValidationPolicyCard({super.key});

  @override
  State<ValidationPolicyCard> createState() => _ValidationPolicyCardState();
}

class _ValidationPolicyCardState extends State<ValidationPolicyCard> {
  bool _photoRequired = true;
  bool _strictZeroNegative = true;

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
              Icon(Icons.policy_rounded, color: Color(0xFF1D4ED8), size: 20),
              SizedBox(width: 12),
              Text(
                'Kebijakan Validasi Lapangan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: const Color(0xFF1D4ED8),
            title: const Text(
              'Wajibkan Foto & Dokumen Lampiran Survei',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            subtitle: const Text(
              'Bila aktif, formulir survei lokasi lapangan wajib menyertakan minimal 1 foto dokumentasi sebelum data tersimpan.',
              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
            value: _photoRequired,
            onChanged: (val) {
              setState(() => _photoRequired = val);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(val ? 'Kebijakan wajib foto survei diaktifkan.' : 'Kebijakan wajib foto survei dinonaktifkan.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const Divider(height: 16, color: Color(0xFFF1F5F9)),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: const Color(0xFF1D4ED8),
            title: const Text(
              'Kebijakan Nilai Numerik Non-Negatif',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            subtitle: const Text(
              'Semua input keuangan, RAB, stok material, dan volume proyek divalidasi tidak boleh bernilai negatif (>= 0).',
              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
            value: _strictZeroNegative,
            onChanged: (val) {
              setState(() => _strictZeroNegative = val);
            },
          ),
        ],
      ),
    );
  }
}

// ── Database Backup Card (v2 Disaster Recovery) ──
class DatabaseBackupCard extends StatelessWidget {
  const DatabaseBackupCard({super.key});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.storage_rounded, color: Color(0xFF0F172A), size: 20),
                  SizedBox(width: 12),
                  Text(
                    'Pencadangan Database (.sql)',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'SEHAT',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Unduh snapshot dump database SIMPRO (.sql) untuk keperluan cadangan berkala, migrasi server, atau mitigasi disaster recovery.',
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF64748B)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Format: MySQL 8.0 · Perkiraan Ukuran Dump: 3.4 MB · Encoding UTF-8mb4',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text('UNDUH CADANGAN BASIS DATA (.SQL)', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D4ED8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mengunduh dump database SIMPRO_arthamasgraha_backup.sql...'),
                    behavior: SnackBarBehavior.floating,
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

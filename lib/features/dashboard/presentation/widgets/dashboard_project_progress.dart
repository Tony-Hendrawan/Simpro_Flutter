import 'package:flutter/material.dart';

class DashboardProjectProgress extends StatelessWidget {
  const DashboardProjectProgress({super.key});

  @override
  Widget build(BuildContext context) {
    // Data proyek persis seperti pada ProjectSeeder dan Dashboard Web
    final projects = [
      (
        code: 'P001',
        name: 'Pembangunan Gedung Kantor PT Maju Jaya',
        location: 'Jakarta Selatan',
        progress: 45.0,
        budget: 'Rp 12.000.000.000',
        spent: 'Rp 5.400.000.000',
        spentPct: '45,0%',
        color: const Color(0xFF1D4ED8),
      ),
      (
        code: 'P002',
        name: 'Renovasi Hotel Bintang Lima Nusantara',
        location: 'Bali',
        progress: 68.0,
        budget: 'Rp 7.500.000.000',
        spent: 'Rp 5.100.000.000',
        spentPct: '68,0%',
        color: const Color(0xFF1D4ED8),
      ),
      (
        code: 'P003',
        name: 'Pembangunan Jembatan Sungai Ciliwung',
        location: 'Bogor',
        progress: 32.0,
        budget: 'Rp 22.000.000.000',
        spent: 'Rp 7.000.000.000',
        spentPct: '31,8%',
        color: const Color(0xFFF59E0B),
      ),
      (
        code: 'P004',
        name: 'Perumahan Green Valley Residence',
        location: 'Tangerang',
        progress: 55.0,
        budget: 'Rp 30.000.000.000',
        spent: 'Rp 16.500.000.000',
        spentPct: '55,0%',
        color: const Color(0xFF1D4ED8),
      ),
      (
        code: 'P006',
        name: 'Pembangunan Gudang Logistik Cikupa',
        location: 'Tangerang',
        progress: 5.0,
        budget: 'Rp 10.000.000.000',
        spent: 'Rp 500.000.000',
        spentPct: '5,0%',
        color: const Color(0xFFF59E0B),
      ),
      (
        code: 'P007',
        name: 'Pembangunan Masjid Al-Ikhlas',
        location: 'Bekasi',
        progress: 72.0,
        budget: 'Rp 3.500.000.000',
        spent: 'Rp 2.500.000.000',
        spentPct: '71,4%',
        color: const Color(0xFF1D4ED8),
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
            children: const [
              Text(
                'Progres Proyek',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                'Lihat Proyek →',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D4ED8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Daftar progres fisik dan realisasi anggaran tiap proyek.',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: projects.length,
            separatorBuilder: (context, index) => const Divider(
              color: Color(0xFFF1F5F9),
              height: 24,
            ),
            itemBuilder: (context, index) {
              final p = projects[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${p.code} · ${p.location}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${p.progress.toInt()}%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: p.progress / 100,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(p.color),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'RAB',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              const SizedBox(height: 2),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  p.budget,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'REALISASI',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              const SizedBox(height: 2),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  p.spent,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Biaya ${p.spentPct} dari RAB',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

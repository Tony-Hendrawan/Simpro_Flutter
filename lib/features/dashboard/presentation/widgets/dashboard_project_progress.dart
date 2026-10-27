import 'package:flutter/material.dart';

class DashboardProjectProgress extends StatelessWidget {
  const DashboardProjectProgress({super.key});

  @override
  Widget build(BuildContext context) {
    const projects = [
      'Pembangunan Gedung Kantor PT Maju Jaya',
      'Renovasi Hotel Bintang Lima Nusantara',
      'Pembangunan Jembatan Sungai Ciliwung',
      'Perumahan Green Valley Residence',
      'Pembangunan Gudang Logistik Cikupa',
      'Pembangunan Masjid Al-Ikhlas',
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
          const Text(
            'Progres Proyek',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: projects.length,
            separatorBuilder: (context, index) => const Divider(
              color: Color(0xFFF1F5F9),
              height: 20,
            ),
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    projects[index],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 1.0,
                      minHeight: 8,
                      backgroundColor: Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1D4ED8)),
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

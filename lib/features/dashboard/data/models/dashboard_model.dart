import 'package:flutter/material.dart';
import '../../domain/entities/dashboard_summary.dart';

class DashboardModel extends DashboardSummary {
  const DashboardModel({
    required super.totalProjects,
    required super.activeProjects,
    required super.completedProjects,
    required super.totalRab,
    required super.realisasiBiaya,
    required super.sisaAnggaran,
    required super.realisasiPercent,
    required super.budgetStatus,
    required super.projectProgress,
    required super.expenseCategories,
    required super.quickActions,
  });

  factory DashboardModel.fromPlaceholder() {
    return const DashboardModel(
      totalProjects: 6,
      activeProjects: 5,
      completedProjects: 1,
      totalRab: 'Rp 132.000.000.000',
      realisasiBiaya: 'Rp 48.000.000.000',
      sisaAnggaran: 'Rp 84.000.000.000',
      realisasiPercent: 36.4,
      budgetStatus: 'Aman',
      quickActions: [
        QuickActionItem(
          title: 'Laporan',
          subtitle: 'Lihat laporan proyek',
          icon: Icons.description_outlined,
        ),
        QuickActionItem(
          title: 'Keuangan',
          subtitle: 'Pantau anggaran proyek',
          icon: Icons.trending_up_rounded,
        ),
        QuickActionItem(
          title: 'Persetujuan Survei',
          subtitle: '0 menunggu tinjauan',
          icon: Icons.fact_check_outlined,
        ),
        QuickActionItem(
          title: 'Pengguna',
          subtitle: 'Kelola akun dan akses',
          icon: Icons.people_outline_rounded,
        ),
      ],
      projectProgress: [
        ProjectProgressItem(
          projectName: 'Pembangunan Gedung Kantor PT Maju Jaya',
          progressFisik: 45.0,
          rab: 'Rp 12.000.000.000',
          realisasi: 'Rp 5.400.000.000',
          realisasiPercent: 45.0,
        ),
        ProjectProgressItem(
          projectName: 'Renovasi Hotel Bintang Lima Nusantara',
          progressFisik: 68.0,
          rab: 'Rp 7.500.000.000',
          realisasi: 'Rp 5.100.000.000',
          realisasiPercent: 68.0,
        ),
        ProjectProgressItem(
          projectName: 'Pembangunan Jembatan Sungai Ciliwung',
          progressFisik: 32.0,
          rab: 'Rp 22.000.000.000',
          realisasi: 'Rp 7.000.000.000',
          realisasiPercent: 31.8,
        ),
        ProjectProgressItem(
          projectName: 'Perumahan Green Valley Residence',
          progressFisik: 55.0,
          rab: 'Rp 30.000.000.000',
          realisasi: 'Rp 16.500.000.000',
          realisasiPercent: 55.0,
        ),
        ProjectProgressItem(
          projectName: 'Pembangunan Gudang Logistik Cikupa',
          progressFisik: 5.0,
          rab: 'Rp 10.000.000.000',
          realisasi: 'Rp 500.000.000',
          realisasiPercent: 5.0,
        ),
        ProjectProgressItem(
          projectName: 'Pembangunan Masjid Al-Ikhlas',
          progressFisik: 72.0,
          rab: 'Rp 3.500.000.000',
          realisasi: 'Rp 2.500.000.000',
          realisasiPercent: 71.4,
        ),
      ],
      expenseCategories: [
        ExpenseCategoryItem(
          category: 'Alat Berat',
          amount: 895000000,
          amountFormatted: 'Rp 895.000.000',
          color: Color(0xFF0284C7),
        ),
        ExpenseCategoryItem(
          category: 'Material',
          amount: 410000000,
          amountFormatted: 'Rp 410.000.000',
          color: Color(0xFF10B981),
        ),
        ExpenseCategoryItem(
          category: 'Peralatan',
          amount: 35000000,
          amountFormatted: 'Rp 35.000.000',
          color: Color(0xFF8B5CF6),
        ),
        ExpenseCategoryItem(
          category: 'Subkontraktor',
          amount: 2500000000,
          amountFormatted: 'Rp 2.500.000.000',
          color: Color(0xFF1D4ED8),
        ),
        ExpenseCategoryItem(
          category: 'Tenaga Kerja',
          amount: 380000000,
          amountFormatted: 'Rp 380.000.000',
          color: Color(0xFFF59E0B),
        ),
      ],
    );
  }
}
